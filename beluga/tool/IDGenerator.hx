package beluga.tool;

class IDGenerator
{
  // TODO :  Improve me that...
  public static function generate(size : UInt) : String
  {    
    var print = new String("qwertyuiopasdfghjklzxcvbnm789456123");
    var key : String = "0";
    for (i in 0...size-1)
    {
      key += print.charAt(Std.random(print.length));
    }
    return (key);
  }
}