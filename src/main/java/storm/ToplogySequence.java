package storm;

import backtype.storm.Config;
import backtype.storm.LocalCluster;
import backtype.storm.topology.TopologyBuilder;
import backtype.storm.utils.Utils;
import storm.bolt.EchoBoltA;
import storm.bolt.EchoBoltB;
import storm.spout.HelloSpout;

public class ToplogySequence {
/*
 * 토폴로지를 정의할때, 
 * HelloSpout은 hs라는 ID로 생성을 할것이고, 
 * EchoBoltA는 eba라는 ID로, 
 * EchoBoltB는 ebb라는 이름으로 생성을 할것이다.
 * */
	
	public static void main(String[] args) {
		TopologyBuilder builder = new TopologyBuilder();
		// Spout 생성 , setSpout(“{id}”,”{Spout 객체}”,”{Parallelism 힌트}”) 로 구성
		// id = hs, Spout객체 = HelloSpout
		builder.setSpout("hs", new HelloSpout(),1);
		
		//Bolt 생성
		//shufflerGrouping = Spout와 Bolt를 연결하는 Grouping 개념
		
		// EchoBoltA가 자신을 eba로 id 생성후, shuffleGrouping("hs") 선언 = "hs"라는 ID를 가지고 있는 Spout나 Bolt로 부터 메시지를 받아 들이겠다.
		builder.setBolt("eba", new EchoBoltA(),1).shuffleGrouping("hs");
		
		// EchoBoltB가 자신을 ebb로 id 생성후, shuffleGrouping("eba") 선언 =  "eba"라는 ID를 가지고 있는 Spout나 Bolt로 부터 메시지를 받아 들이겠다.
		// = 즉 앞서 생성한 EchoBoltA로 부터 메세지를 받아들이겠다.
		builder.setBolt("ebb", new EchoBoltB(),1).shuffleGrouping("eba");
		
		Config conf = new Config();
		conf.setDebug(true);
		LocalCluster cluster = new LocalCluster();
		
		cluster.submitTopology("ToplogySequence", conf,builder.createTopology());
		
		
		Utils.sleep(10000);
		
		cluster.killTopology("ToplogySequence");
		
		cluster.shutdown();   
	}
	/*
	5399 [Thread-12-hs] INFO  backtype.storm.daemon.task - Emitting: hs default [hello world 1]
		->  12번 쓰레드에서 hs 라는 이름의 Spout가 "hello world 1" 문자열 emit
	
	5400 [Thread-8-eba] INFO  backtype.storm.daemon.executor - Processing received message source: hs:4, stream: default, id: {}, [hello world 1]
		->  8번 쓰레드에서 수행되는 “eba”라는 Bolt가 “hs”라는  Spout또는 Bolt에서 “hello world”라는 문자열을 받았다. 
		        	
	Hello I am Bolt A: hello world 1
		->  그 다음 라인에 “Hello I am Bolt A: hello world 1”가 출력되는 것을 확인할 수 있다.
	
	5401 [Thread-8-eba] INFO  backtype.storm.daemon.task - Emitting: eba default [Hello I am Bolt A :hello world 1]
		->  8번 쓰레드에서 수행되는 “eba” 볼트가 “Hello I am Bolt A :hello world 1” 라는 문자열을 제출하였다.
	
	5409 [Thread-10-ebb] INFO  backtype.storm.daemon.executor - Processing received message source: eba:2, stream: default, id: {}, [Hello I am Bolt A :hello world 1]
		-> 10번 쓰레드에서 수행되는 “ebb”라는 id의 볼트가 “eba”로 부터  “Hello I am Bolt A :hello world 1” 라는 메세지를 받았다
		
	Hello I am Bolt B: Hello I am Bolt A :hello world 1
		-> I am Bolt B: Hello I am Bolt A :hello world 1” 문자열이 출력되었음을 확인할 수 있다.


*/
}
