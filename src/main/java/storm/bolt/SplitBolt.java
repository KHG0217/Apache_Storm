package storm.bolt;

import java.util.Map;

import backtype.storm.task.OutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseRichBolt;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Tuple;
import backtype.storm.tuple.Values;

public class SplitBolt extends BaseRichBolt {

	private OutputCollector collector;
	
	public void execute(Tuple tuple) {
		try {
			Thread.sleep(5000);
			String sentence = tuple.getStringByField("sentence");
			String[] words = sentence.split(" ");		
			
			for (String word : words) {
				System.out.println("bolt:" +word);
				this.collector.emit(new Values(word));
			}	
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	
	}
	
	// bolt = 초기화 메서드? = 한번만 가져오게
	public void prepare(Map map, TopologyContext context, OutputCollector outputCollectorctor) {
		this.collector = outputCollectorctor;
		
	}

	public void declareOutputFields(OutputFieldsDeclarer declarer) {
		declarer.declare(new Fields("word"));
		
	}

}
