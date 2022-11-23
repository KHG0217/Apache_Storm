package storm.bolt;

import backtype.storm.topology.BasicOutputCollector;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseBasicBolt;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Tuple;
import backtype.storm.tuple.Values;

/*
 * 	Bolt : 데이터 처리
 * 		-> 튜플을 받아 실제 분산 작업을 수행하며, 필터링, 집계, 조인등의 연산을 병렬로 실행
 * 
 * 	HelloSpout에서 생성된 데이터는 HelloBolt로 들어오게 되는데,
 * 		
 * 		1. 데이터가 들어오면 execute라는 메서드가 자동으로 수행됨
 * 		
 * 		2. Tuple을 통해 데이터가 전달됨
 * 		
 * 		3. 여기서는 Tuple의 이름이 "say"인 값을 tuple.getStringByField("say")를 이용해서 꺼낸 후 
 * 		   System.out으로 출력했다.
 * 		
 * 			* 데이터를 다음 플로우로 보내고자 할때는 collector.emit을 이용해 다음 플로우로 보내고
 * 			  declareOutputFields에서 그 데이터에 대한 필드를 정의하면 된다.
 * 
 * 		4. 데이터를 생성하는 Spout와 데이터를 처리하는 Bolt를 구현했으면 이둘을 연결시켜주는 Topology 필요
 */
public class HelloBolt extends BaseBasicBolt {

	public void execute(Tuple tuple, BasicOutputCollector collector) {
		String value = tuple.getStringByField("say");
		System.out.println("Tuple value is" + value);
		
		// collector.emit(new Values("test")); 다음 플로우로 보내고자 할때 
	}

	public void declareOutputFields(OutputFieldsDeclarer declarer) {
		// declarer.declare(new Fields("testFiles")); //다음 플로우에서 필드 정의
		
	}

}
