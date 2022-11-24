package storm.bolt;

import java.util.HashMap;
import java.util.Map;

import backtype.storm.task.OutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseRichBolt;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Tuple;
import backtype.storm.tuple.Values;

public class WordCountBolt extends BaseRichBolt {
	private OutputCollector collector;
	private HashMap<String, Long> counter = null;
	
	public void execute(Tuple tuple) {
		String word = tuple.getStringByField("word");
		Long count = this.counter.get(word);
	
		count = count==null ? 1 : count + 1;
		this.counter.put(word, count);
		this.collector.emit(new Values(word,count));
	}

	public void prepare(Map map, TopologyContext topologyContext, OutputCollector outputCollector) {
		this.collector = outputCollector;
		this.counter = new HashMap<String, Long>();
		
	}

	public void declareOutputFields(OutputFieldsDeclarer outputFieldsDeclarer) {
		outputFieldsDeclarer.declare(new Fields("word","count"));
		
	}

}
