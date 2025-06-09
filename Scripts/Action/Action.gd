extends Resource
class_name Action

var next_action: Action
var source: CardData
var result: ActionResult
var cancelled := false

@export_multiline var reminder_text: String

static func Create(_source: CardData, _result: ActionResult = ActionResult.Empty()) -> Action:
	var out = new()
	out.source = _source
	out.result = _result
	return out

func resolve(ctx: GameState, input: ActionResult = ActionResult.Empty()) -> Action:
	if next_action:
		await ctx.update()
		await next_action.resolve(ctx, input)
	return self

## Consider the architecture here carefully!
# I want to be able to chain actions using the result of the previous action
# What if the action result doesn't match the next action input?
func then(action: Action) -> Action:
	next_action = action
	return next_action

func description(text: String) -> Action:
	reminder_text = text
	return self

func withResult(_result: ActionResult) -> Action:
	result = _result
	return self
