extends Node
## You should autoload but make sure to call [method initialize] before
## using the logging methods in this class

var VERSION = 2

# these enums are important and should be updated when stuff changes
enum ACTIONS {
	JUMP = 1,
	AIRJUMP = 2,
	DASH = 4,
	WALLJUMP = 6,
	BOUNCE = 7,
	ON_COOLDOWN = 8,

	LEAVE_START = 40,
	ENTER_START = 41,
	ENTER_END = 42,
	ENTER_CHECKPOINT = 43,

	PLAYER_DIE = 60,

	QUIT_LEVEL = 100,

	QUIT = 400,
	ENTER_DEV_SETTINGS = 500
}

enum LEVELS {
	TUTORIAL_BASIC = 900,
	TUTORIAL_ADVANCED = 901,
	TESTLEVEL = 902,
	TUTORAL_ADVANCED2 = 903,
	LEVEL1 = 1,
	DEARYOU_WALLJUMP = 2,
	CIRCUS = 3,
}


const prdUrl: String = "https://integration.centerforgamescience.org/cgs/apps/games/v2/index.php/"
# const prdUrl: String = "http://127.0.0.1:8888/"

# Properties specific to each game
var gameId: int
var gameName: String
var gameKey: String
var categoryId: int
var versionNumber: int

# Logging state
var currentUserId: String
var currentSessionId: String
var currentDqid: String
var currentLevelId: int

var currentLevelSeqInSession: int
var currentActionSeqInSession: int
var currentActionSeqInLevel: int

var timestampOfPrevLevelStart: int
var timestampOfPrevAction: int = cur_time_millis()

var levelActionBuffer: Array

var session_started = false

func _ready():
	Globals.LOGGING_ENABLED = false if OS.is_debug_build() else true  # comment this out for logging in debug builds
	var cid = 1 if OS.is_debug_build() else VERSION
	self.initialize(202304, "group04", "3b45e8ea6b313e516d18679e04be7779", cid)
	start_new_session()
	# actually blocking like this seems to not give the request a chance to be sent
	# if not OS.is_debug_build():  # don't pause and wait cause we don't really care about session ids for testing builds
	# 	while not session_started:
	# 		OS.delay_msec(25)  # pause until response received from database
	# while not session_started:
	# 	print("still waiting for response")
	# 	OS.delay_msec(25)  # pause until response received from database


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		log_action_with_no_level(ACTIONS.QUIT, JSON.print({"time": Time.get_ticks_msec()}))
		get_tree().quit()


func initialize(_gameId: int, _gameName: String, _gameKey: String, _categoryId: int):
	self.gameId = _gameId
	self.gameName = _gameName
	self.gameKey = _gameKey
	self.categoryId = _categoryId
	self.versionNumber = 1

	self.levelActionBuffer = []


func generate_uuid():
	var s = v4()  # code from someone else, see way bottom of script
	print("Generated ID: " + s)
	return s


func get_saved_user_id() -> String:
	var file = File.new()
	file.open("user://user_id.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	print("Retrieving User ID: " + content)
	return content


func set_saved_user_id(value: String):
	print("Setting User ID: " + value)
	var file = File.new()
	file.open("user://user_id.dat", File.WRITE)
	file.seek(0)
	file.store_string(value)
	file.close()


func start_new_session():
	if not Globals.LOGGING_ENABLED:
		return
	print("starting new session")
	var uuid = get_saved_user_id()
	if uuid == "":
		uuid = generate_uuid()
		set_saved_user_id(uuid)

	start_new_session_with_uuid(uuid)


func start_new_session_with_uuid(userId: String):
	if not Globals.LOGGING_ENABLED:
		return
	self.currentUserId = userId
	self.currentLevelSeqInSession = 0
	self.currentActionSeqInLevel = 0

	var sessionParams = {
		"eid": 0,
		"cid": self.categoryId,
		"pl_detail": {},
		"client_ts": cur_time_millis(),
		"uid": self.currentUserId,
		"g_name": self.gameName,
		"gid": self.gameId,
		"svid": 2,
		"vid": self.versionNumber
	}
	var requestParams = prepare_params(sessionParams)

	var req = send_post_request("loggingpageload/set/", requestParams)
	var result = yield(req, "request_completed")
	if result[0] == HTTPRequest.RESULT_SUCCESS and result[1] == 200:
		# print(result)
		var text = result[3].get_string_from_utf8()
		print("LOGGER: session start response body text: " +text)
		text = text.substr(5)  # get just the body
		var parsed_results = JSON.parse(text).result
		if parsed_results["tstatus"] == "t":
			self.currentSessionId = parsed_results["r_data"]["sessionid"]

	else:
		printerr("------- Error response to session start log")
		printerr(result)
		printerr("body: " + result[3].get_string_from_utf8())

	# let the player play even if session fails to start
	session_started = true


func log_level_start(levelId: int, details: String):
	if not Globals.LOGGING_ENABLED:
		return
	print("log level start " + str(levelId))
	self.flush_buffered_level_actions()

	self.timestampOfPrevLevelStart = cur_time_millis()
	self.currentActionSeqInLevel = 0
	self.currentLevelId = levelId
	self.currentDqid = ""

	var startData = get_common_data()
	startData["sessionid"] = self.currentSessionId
	startData["sid"] = self.currentSessionId
	startData["quest_seqid"] = ++self.currentLevelSeqInSession
	startData["qaction_seqid"] = ++self.currentActionSeqInLevel
	startData["q_detail"] = details
	startData["q_s_id"] = 1
	startData["session_seqid"] = ++self.currentActionSeqInSession

	var requestParams = prepare_params(startData)
	var result = yield(send_post_request("quest/start/", requestParams), "request_completed")
	if result[0] == HTTPRequest.RESULT_SUCCESS and result[1] == 200:
		# print(result)
		var text = result[3].get_string_from_utf8()
		print("LOGGER: level start response body text: " + text)
		text = text.substr(5)  # get just the body
		var parsed_results = JSON.parse(text).result
		if parsed_results["tstatus"] == "t":
			self.currentDqid = parsed_results["dqid"]
	else:
		printerr("------- Error response to level start log")
		printerr(result)
		printerr("body: " + result[3].get_string_from_utf8())


func log_level_end(details: String):
	if not Globals.LOGGING_ENABLED:
		return
	self.flush_buffered_level_actions()

	var endData = get_common_data()
	endData["sessionid"] = self.currentSessionId
	endData["sid"] = self.currentSessionId
	endData["qaction_seqid"] = ++self.currentActionSeqInLevel
	endData["q_detail"] = details
	endData["q_s_id"] = 0
	endData["dqid"] = self.currentDqid
	endData["session_seqid"] = ++self.currentActionSeqInSession

	var requestParams = prepare_params(endData)
	var _a = send_post_request("quest/end/", requestParams)

	self.currentDqid = ""


func log_level_action(actionId: int, details: String):
	if not Globals.LOGGING_ENABLED:
		return
	var timestampOfAction = cur_time_millis()
	var relativeTime = timestampOfAction - self.timestampOfPrevLevelStart

	var individualAction = {
		"detail": details,
		"client_ts": timestampOfAction,
		"ts": relativeTime,
		"te": relativeTime,
		"session_seqid": ++self.currentActionSeqInSession,
		"qaction_seqid": ++self.currentActionSeqInLevel,
		"aid": actionId
	}
	self.levelActionBuffer.append(individualAction)

	var timeSinceLastAction = timestampOfAction - cur_time_millis()
	if levelActionBuffer.size() >= 5 or timeSinceLastAction > 2000:
		self.flush_buffered_level_actions()

	self.timestampOfPrevAction = cur_time_millis()


func log_action_with_no_level(actionId: int, details: String):
	if not Globals.LOGGING_ENABLED:
		return
	var actionNoLevelData = {
		"session_seqid": ++self.currentActionSeqInSession,
		"cid": self.categoryId,
		"client_ts": cur_time_millis(),
		"aid": actionId,
		"vid": self.versionNumber,
		"uid": self.currentUserId,
		"g_name": self.gameName,
		"a_detail": details,
		"gid": self.gameId,
		"svid": 2,
		"sessionid": self.currentSessionId
	}

	var requestParams = prepare_params(actionNoLevelData)
	var _a = send_post_request("loggingactionnoquest/set/", requestParams)


func flush_buffered_level_actions():
	if self.levelActionBuffer.size() > 0 && self.currentDqid != "":
		print("Flushing " + str(self.levelActionBuffer.size()) + " actions")
		var bufferedActionsData = self.get_common_data();
		bufferedActionsData["actions"] = self.levelActionBuffer
		bufferedActionsData["dqid"] = self.currentDqid

		var requestParams = prepare_params(bufferedActionsData)
		var _a = send_post_request("logging/set/", requestParams)

		self.levelActionBuffer = []


## [method yield] on the return of this function (object) for signal "request_completed"
## in order to block and get the results of the request returned in an array
## by the yield function, where httprequest signal handler args are in order:
## result, response_code, headers, body
func send_post_request(suffix: String, parameters: Dictionary) -> HTTPRequest:
	# for some reason the `query_string_from_dict` method is only available on instances!
	# guess the devs didn't think anyone would try to make application/x-www-form-urlencoded requests from HTTPRequest nodes
	var dummyclient: = HTTPClient.new()

	var req = HTTPRequest.new()
	add_child(req)
	var query_string = dummyclient.query_string_from_dict(parameters)
	var headers = ["Accept: */*","Content-Type: application/x-www-form-urlencoded"]
	var rescode = req.request(compose_url(suffix), headers, false, HTTPClient.METHOD_POST, query_string)
	print("LOGGER: request sent to " + compose_url(suffix) + " got godot result code " + str(rescode) + " (0 = OK)")
	return req


func compose_url(suffix: String) -> String:
	var baseUrl = prdUrl
	return baseUrl + suffix


func get_common_data() -> Dictionary:
	return {
		"client_ts": cur_time_millis(),
		"cid": self.categoryId,
		"svid": 2,
		"lid": 0,
		"vid": self.versionNumber,
		"qid": self.currentLevelId,
		"g_name": self.gameName,
		"uid": self.currentUserId,
		"sid": self.currentSessionId,
		"g_s_id": self.gameId,
		"tid": 0,
		"gid": self.gameId
	}


func prepare_params(data: Dictionary) -> Dictionary:
	var stringified_data = JSON.print(data) if data != null else "null"
	var request_blob: Dictionary = {
		"dl": "0",
		"latency": "5",
		"priority": "1",
		"de": "0",
		"noCache": "",
		"cid": str(self.categoryId),
		"gid": str(self.gameId),
		"data": stringified_data,
		"skey": self.encoded_data(stringified_data)
	}
	return request_blob


func encoded_data(value: String):
	if value == null:
		value = ""

	var salt: String = value + self.gameKey
	return salt.md5_text()


func in_session() -> bool:
	return self.currentSessionId != null


func cur_time_millis() -> int:
	return int(total_milliseconds(Time.get_unix_time_from_system()))


func total_milliseconds(unix_timestamp: float):
	return unix_timestamp * 1000

# Code from https://github.com/binogure-studio/godot-uuid

# Note: The code might not be as pretty it could be, since it's written
# in a way that maximizes performance. Methods are inlined and loops are avoided.
const MODULO_8_BIT = 256

static func getRandomInt():
  # Randomize every time to minimize the risk of collisions
  randomize()

  return randi() % MODULO_8_BIT

static func uuidbin():
  # 16 random bytes with the bytes on index 6 and 8 modified
  return [
	getRandomInt(), getRandomInt(), getRandomInt(), getRandomInt(),
	getRandomInt(), getRandomInt(), ((getRandomInt()) & 0x0f) | 0x40, getRandomInt(),
	((getRandomInt()) & 0x3f) | 0x80, getRandomInt(), getRandomInt(), getRandomInt(),
	getRandomInt(), getRandomInt(), getRandomInt(), getRandomInt(),
  ]

static func v4():
  # 16 random bytes with the bytes on index 6 and 8 modified
  var b = uuidbin()

  return '%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x' % [
	# low
	b[0], b[1], b[2], b[3],

	# mid
	b[4], b[5],

	# hi
	b[6], b[7],

	# clock
	b[8], b[9],

	# clock
	b[10], b[11], b[12], b[13], b[14], b[15]
  ]
