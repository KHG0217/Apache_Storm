package storm.bolt;

import backtype.storm.topology.BasicOutputCollector;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseBasicBolt;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Tuple;
import backtype.storm.tuple.Values;

public class EchoBoltA extends BaseBasicBolt {

	public void execute(Tuple tuple, BasicOutputCollector collector) {
		
		String value = tuple.getStringByField("say");
		System.out.println("Hello I am Bolt A : " + value);
		collector.emit(new Values("Hello I am Bolt A : " + value));
		
	}


	public void declareOutputFields(OutputFieldsDeclarer declarer) {
		declarer.declare(new Fields("say"));
		
	}


}
