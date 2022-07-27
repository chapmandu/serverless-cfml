component {

	public function init(event, context) {
		this.event = arguments.event;
		this.context = arguments.context;
		return this;
	}

	public struct function handler() {
		return {"uuid": CreateUUID()};
	}

	public string function hello() {
		return "Hello World!";
	}

	public array function goodbye() {
		return ["Goodbye cruel world!"];
	}

	public struct function bark() {
		return {"Woof": true};
	}

}
