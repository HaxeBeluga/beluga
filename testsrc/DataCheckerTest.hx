package;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import beluga.tool.DataChecker;

class DataCheckerTest
{
    public function new()
    {

    }

    @BeforeClass
    public function beforeClass(): Void {
    }

    @AfterClass
    public function afterClass(): Void {
    }

    @Test
    public function testExample(): Void {
        Assert.isTrue(true);
    }

    @Test
    public function checkMinValueIsBiggerThanFormValueTrue(): Void {
        var test_result = DataChecker.checkMinValue(42, 84);
        Assert.isTrue(test_result); 
    }
    
    @Test
    public function checkMinValueIsBiggerThanFormValueFalse(): Void {
        var test_result = DataChecker.checkMinValue(84, 42);
        Assert.isFalse(test_result); 
    }

    @Test
    public function checkFormValueIsBiggerThanMinValueTrue(): Void {
        var test_result = DataChecker.checkMaxValue(84, 42);
        Assert.isTrue(test_result); 
    }
    
    @Test
    public function checkFormValueIsBiggerThanMinValueFalse(): Void {
        var test_result = DataChecker.checkMaxValue(42, 84);
        Assert.isFalse(test_result); 
    }
    
    @Test
    public function checkFormValueIsInTheRange(): Void {
        var test_result = DataChecker.checkRangeValue(84, 42, 128);
        Assert.isFalse(test_result); 
    }
    
    @Test
    public function checkFormValueIsNotInTheRange(): Void {
        var test_result = DataChecker.checkRangeValue(42, 84, 128);
        Assert.isFalse(test_result); 
    }

    @Test
    public function checkFormValueIsEqualToGivenValue(): Void {
        var test_result = DataChecker.checkEqualValue(84, 84);
        Assert.isTrue(test_result); 
    }
    
    @Test
    public function checkFormValueIsNotEqualToGivenValue(): Void {
        var test_result = DataChecker.checkEqualValue(42, 84);
        Assert.isFalse(test_result); 
    }

    @Test
    public function checkFormValueHasAtLeastTheMinimalLength(): Void {
        var test_result = DataChecker.checkMinLength("hello", 3);
        Assert.isTrue(test_result); 
    }
    
    @Test
    public function checkFormValueHasNotTheMinimalLength(): Void {
        var test_result = DataChecker.checkMinLength("hello", 8);
        Assert.isFalse(test_result); 
    }

    @Test
    public function checkFormValueHasAtLeastTheMaxLength(): Void {
        var test_result = DataChecker.checkMaxLength("hello", 3);
        Assert.isFalse(test_result); 
    }
    
    @Test
    public function checkFormValueHasNotTheMaxLength(): Void {
        var test_result = DataChecker.checkMaxLength("hello", 8);
        Assert.isTrue(test_result); 
    }

    @Test
    public function checkFormValueHasEqualLength(): Void {
        var test_result = DataChecker.checkEqualLength("hello", 5);
        Assert.isTrue(test_result); 
    }
    
    @Test
    public function checkFormValueHasNotEqualLength(): Void {
        var test_result = DataChecker.checkEqualLength("hello", 8);
        Assert.isFalse(test_result); 
    }

    @Test
    public function checkPatternMatch(): Void {
        var filter:EReg = ~/[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z][A-Z][A-Z]?/i;
        var test_result = DataChecker.checkMatch("john.doe@gmain.com", filter);
        Assert.isTrue(test_result); 
    }
    
    @Test
    public function checkPatternDontMatch(): Void {
        var filter:EReg = ~/[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z][A-Z][A-Z]?/i;
        var test_result = DataChecker.checkMatch("blah blah blah", filter);
        Assert.isFalse(test_result); 
    }
}