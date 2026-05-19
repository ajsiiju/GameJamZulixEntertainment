extends RichTextLabel


static var debugChat: RichTextLabel
const VISIBLE_MESSAGES = 20

var labels = []

func _ready():
	debugChat = self

func message(new_text: String):
	if debugChat:
		if (labels.size() > VISIBLE_MESSAGES):
			labels.pop_back()
		labels.insert(0, new_text)
		debugChat.text = str(labels)

func _input(event):
		if event.is_action("ui_accept"):
			labels.clear()
			debugChat.text = str(labels)
