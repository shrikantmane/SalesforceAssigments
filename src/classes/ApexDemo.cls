public with sharing class ApexDemo {
	
    public static void GetFibonacciSeries(Integer maxNumber){
    	if(maxNumber<=1){
	    	System.debug('Number should be greater than 1');
	    	return;
    	}
    	System.debug('Fibonacci Series for the number '+maxNumber+' :');
    	List<Decimal> fSeries = new List<Decimal>{1, 1};
		System.debug(1);
		System.debug(1);
		for(Integer i=2;i<maxNumber;i++){
		    Decimal nextNum = fSeries[i-1]+ fSeries[i-2];
		    fseries.add(nextNum);
		    System.debug(nextNum);
		}
    }
    
    
    
    public String ReverseString(string inputString){
    	return inputString.reverse();
	}
	public String ReplaceString(string inputString, string target, string replacement){
    	return inputString.replace(target,replacement );
	}
  public abstract class MathOps {
  	public abstract void AddNumbers(Integer Num1, Integer Num2);  	
  }
  
  public class Employee extends MathOps
  {
	  public override void AddNumbers(Integer Num1, Integer Num2){
	  	System.debug('Hello');
		  	System.debug(Num1 + Num2);
		  }  
  }
}