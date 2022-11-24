package storm.spout;

import java.util.Map;

import backtype.storm.spout.SpoutOutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseRichSpout;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Values;

public class WordCountSpout extends BaseRichSpout {
	
	private SpoutOutputCollector collector;
	private int index = 0;
	private final String[] sentences = {
			
			"1",
			"2",
			"3"
						
	};
	
	public void nextTuple() {
		System.out.println("spout: " + sentences[index]);
		this.collector.emit(new Values(sentences[index]));
		index++;
	
		if(index >= sentences.length) {
			index = 0;
			
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}

	}

	public void open(Map map, TopologyContext topologyContext, SpoutOutputCollector spoutOutputCollector) {
		this.collector = spoutOutputCollector;
		
	}
	
	public void declareOutputFields(OutputFieldsDeclarer outputFieldsDeclarer) {
		outputFieldsDeclarer.declare(new Fields("sentence"));
		
	}
}
