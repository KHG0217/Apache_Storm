package storm;

import backtype.storm.Config;
import backtype.storm.LocalCluster;
import backtype.storm.topology.TopologyBuilder;
import backtype.storm.tuple.Fields;
import backtype.storm.utils.Utils;
import storm.bolt.ReportBolt;
import storm.bolt.SplitBolt;
import storm.bolt.WordCountBolt;
import storm.spout.WordCountSpout;

public class WordCountTopology {
    private static final String WORDCONTCOUNT_SPOUT_ID = "wordcount-spout";
    private static final String SPLIT_BOLT_ID = "split-bolt";
    private static final String COUNT_BOLT_ID = "count-bolt";
    private static final String REPORT_BOLT_ID = "report-bolt";
    private static final String TOPOLOGY_NAME = "word-count-topology";
    
	public static void main(String[] args) {
		WordCountSpout spout = new WordCountSpout();
		
		SplitBolt splitBolt = new SplitBolt();
		WordCountBolt countBolt = new WordCountBolt();
		ReportBolt reportBolt = new ReportBolt();
		
		TopologyBuilder builder = new TopologyBuilder();
		
		// Spout 연결
		builder.setSpout(WORDCONTCOUNT_SPOUT_ID, spout); // Executor 과 Task 수 2개
		
		//Bolt 연결  1:1
		builder.setBolt(SPLIT_BOLT_ID, splitBolt) // Spout -> SplitBolt
						//.setNumTasks(4) // SplitBolt의 Task 수 4개 
						.shuffleGrouping(WORDCONTCOUNT_SPOUT_ID);
		
													 // countBolt의 Executor 개수와 Task개수 4개
		builder.setBolt(COUNT_BOLT_ID, countBolt) // SplitBolt -> CountBolt
						.fieldsGrouping(SPLIT_BOLT_ID, new Fields("word"));
		
//		builder.setBolt(REPORT_BOLT_ID, reportBolt) // CountBolt -> ReportBolt
//						.globalGrouping(COUNT_BOLT_ID);
		
		
				
		LocalCluster cluster = new LocalCluster();
		
		Config conf = new Config();
		conf.setDebug(true);
		conf.setNumWorkers(2); // 이 토폴로지에서 사용한 Worker 프로세스 수 2개
		
		// 스파우트와 볼트 사이의 처리속도를 맞추기 위해 송수신 큐 사이즈를 최소화
//		conf.put(Config.TOPOLOGY_EXECUTOR_RECEIVE_BUFFER_SIZE, new Integer(1));
//		conf.put(Config.TOPOLOGY_EXECUTOR_SEND_BUFFER_SIZE, new Integer(1));
//		conf.put(Config.TOPOLOGY_RECEIVER_BUFFER_SIZE, new Integer(1));
//		conf.put(Config.TOPOLOGY_TRANSFER_BUFFER_SIZE, new Integer(1));
		
		cluster.submitTopology(TOPOLOGY_NAME, conf, builder.createTopology());
		
		Utils.sleep(500000);
		
		cluster.killTopology(TOPOLOGY_NAME);
		
		cluster.shutdown();
	}

}
