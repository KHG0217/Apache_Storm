package storm.spout;

import java.util.Map;

import backtype.storm.spout.SpoutOutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseRichSpout;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Values;

/*	
 * 	Spout : 데이터 생성
 * 			-> 외부로부터 데이터를 유입받아, 가공 처리를해서 튜플을 생성, 이후 해당 튜플을 Bolt에 전송
 * 
 *  HelloSpout가 실행되면
 *  	1. 필드 "say"에 값이 "hello world"인 데이터를 생성해서 다음 워크 플로우로 보낸다.
 *  	
 *  	2. nextTuple() 이라는 함수에서 외부 데이터를 받아들여 다음 워크 플로우로 보내는 일을 하는데,
 *  	       여기서는 외부에서 데이터를 받아들이지 않고 자체적으로 데이터를 생성하도록 한다.
 *  	
 *  	3. 데이터를 뒤에 워크플로우에 보내는 함수는 emit인데,emit부분에 "hello world"라는 value를 넣어서 보내도록 했다.
 *  
 *  	4. 필드값은 declareOutputFields라는 함수에 정의하는데, 데이터의 필드는 "say"로 정의하였다.
 */
public class HelloSpout extends BaseRichSpout {
	private static final long seriaVersionUID = 1L;
	private static int count=0;
	private SpoutOutputCollector collector;

	public void open(Map conf, TopologyContext context, SpoutOutputCollector collector) {
		this.collector = collector;
	}	

	public void nextTuple() {
		// emit : 데이터를 워크플로우에 보내는 함수 
		this.collector.emit(new Values("hello world"));	
	}


	public void declareOutputFields(OutputFieldsDeclarer declarer) {
		declarer.declare(new Fields("say"));	
		
	}

}
