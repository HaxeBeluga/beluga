package beluga.tool;

class IDGenerator
{
  // TODO :  Need to generate a reald random string SHA1 or MD5
  // for example.
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