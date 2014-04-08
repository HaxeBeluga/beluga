package beluga.tool;

class IDGenerator
{
  // TODO :  Improve me that...
  public static function generate(size : UInt) : String
  {
    var key = new String();
    
    key = Std.string(Date.now());
    if (key.length > size)
    {
      key = key.substring(key.length - size, key.length);
    }
    else if (key.length < size)
    {
      key = StringTools.rpad(key, "0", size);    
    }
    return (key);
  }
}