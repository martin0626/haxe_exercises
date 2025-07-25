import Test;

class Dog extends Test {
    public function new(name: String = 'Marto') {
        super(name);
    }

    public override function greet(): String {
        return 'Hi! I am ${this.name} the Dog!';
    }

    public static function bark(): String {
        return 'Bark!';
    }
}