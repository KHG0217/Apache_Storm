package storm.bolt;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import backtype.storm.task.OutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseRichBolt;
import backtype.storm.tuple.Tuple;

public class ReportBolt extends BaseRichBolt{
	private Map<String, Long> counter = null;
	
	public void execute(Tuple tuple) {
		String word = tuple.getStringByField("word");
		Long count = tuple.getLongByField("count");
		this.counter.put(word, count);
		
	}

	public void prepare(Map map, TopologyContext topologyContext, OutputCollector outputCollector) {
		this.counter = new HashMap<String, Long>();
	}

	public void declareOutputFields(OutputFieldsDeclarer arg0) {
		
	}
	
	// Bolt가 셧다운될때 실행되는 메소드
	@Override
	public void cleanup() {
		//Object[] mapKey = this.counter.keySet().toArray();
		//Arrays.sort(mapKey);
		
		//System.out.println("Test : " + this.counter.keySet());
		

		/* 정렬사용 x */	
		System.out.println("------FINAL COUNT -------");
		for(String key : this.counter.keySet()) {			
			System.out.println(key + ":" + this.counter.get(key));
		}
		System.out.println("---------------------------");
		
		/* Key 값으로 정렬(오름차순/내림차순) */
		List<String> keySet = new ArrayList<String>(this.counter.keySet());
		
		// key 값으로 오름차순 정렬
		Collections.sort(keySet);
		
		System.out.println("------FINAL COUNT(Key: Ascending Order) -------");
		for (String key : keySet) {
            System.out.println(key + ":" + this.counter.get(key));
        }
		System.out.println("---------------------------");
		
		// key 값으로 내림차순 정렬
		Collections.reverse(keySet);
		
		System.out.println("------FINAL COUNT(Key: Dscending Order) -------");
		for (String key : keySet) {
            System.out.println(key + ":" + this.counter.get(key));
        }
		System.out.println("---------------------------");
		        
        /* Comparator를 사용하여 정렬 (Value 값 오름차순) */
		
        // Map.Entry 리스트
        List<Entry<String, Long>> entryList = new ArrayList<Entry<String, Long>>(this.counter.entrySet());
        
        Collections.sort(entryList, new Comparator<Entry<String, Long>>() {
			public int compare(Entry<String, Long> entry, Entry<String, Long> entry2) {
				// 오름차순 정렬
				return entry.getValue().compareTo(entry2.getValue());
			}        	
        });    
        
        System.out.println("------FINAL COUNT(Value: Ascending Order) -------");	
        for(Entry<String, Long> entry : entryList) {
	        System.out.println(entry.getKey() + " : " + entry.getValue());
	        }       
		System.out.println("---------------------------");
		
        /* Comparator를 사용하여 정렬 (Value 값 내림차순) */
        Collections.sort(entryList, new Comparator<Entry<String, Long>>() {

			public int compare(Entry<String, Long> entry, Entry<String, Long> entry2) {
				// 내림차순 정렬
				return entry2.getValue().compareTo(entry.getValue());
			}
        });
        
        System.out.println("------FINAL COUNT(Value: Dscending Order) -------");		
        for(Entry<String, Long> entry : entryList) {
	        System.out.println(entry.getKey() + " : " + entry.getValue());
	        }        
		System.out.println("---------------------------");
	}
	
	
	
}
