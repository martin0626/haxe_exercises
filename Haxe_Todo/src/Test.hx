class Test {
    public var name: String;

    public function new(name: String = "Marto") {
        this.name = name;
    }

    public function greet(): String {
        return 'Hello! I am ${this.name}';
    }
}