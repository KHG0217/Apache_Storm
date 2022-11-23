package storm;

import backtype.storm.Config;
import backtype.storm.LocalCluster;
import backtype.storm.topology.TopologyBuilder;
import backtype.storm.utils.Utils;
import storm.bolt.HelloBolt;
import storm.spout.HelloSpout;
/*
 *  Topology : Spout와  Bolt를 연결시켜주는 역활
 *  	-> Spout-Bolt의 데이터 처리 흐름을 정의, 하나의 Spout와 다수의 Bolt로 구성
 *  
 *  Topology는 데이터를 생성하는 Spout와 데이터를 처리하는 Bolt간의 데이터 흐름을 정의하는 부분이다.
 *  
 *  	1. TopologyBuilder을 이용해서 Topology를 생성
 *  	
 *  	2. setSpout을 이용해서 앞에서 구현한 HelloSpout을 연결한다.
 *  
 *  	3. 그 다음 setBolt를 이용해서 Bolt를 Topology에 연결한다.
 *  
 *  	4. setBolt에 shuffleGrouping 메서드를 이용하여, HelloBolt가 HelloSpout 부터 생성되는 데이터를 읽어들임을 명시한다.
 *  
 *  	5. Config는 Topology가 어떤 서버에서 어떤 포트등을 이용해서 실행되는지 정의할 수있다.
 *  
 *  	6. Topology를 Strom 클러스터에 배포해야하는데, Strom을 개발의 편의를 위해서 두가지 형태의 클러스터를 제공한다.
 *  
 *  	7. 개발용 클러스터, 실운영 환경용 클러스터
 *  
 *  	8. 여기서는 LocalCluster cluster = new LocalCluster(); 을 작성하여, 개발환경용 클러스터를 사용한다.
 *  
 *  	9. 개발 환경에서 최소한 서버만을 가동하여 개발한 토폴로지를 테스트할 수 있게 해준다.
 *  
 *  	10. cluster.submitTopology를 이용하여 개발한 토폴로지를 배포한다.
 *  
 *  	11. HelloSpout가 계속해서 데이터를 생성하고, HelloBolt를 생성된 데이터를 받아서 계속해서 출력한다.
 *  
 *  	12. Utils.sleep(10000); 을 작성하여 10초후에 멈추게 한다.
 *  
 *  	13. 쓰레드는 Sleep으로 가지만, 토폴로지에 생성된 HelloSpout와 HelloBolt 쓰레드는 백그라운드에서 작업을 계속한다.
 *  
 *  	14. 10초후에 killTopology를 이용해서 해당 토폴로지를 제거하고 shutdown을 이용해서 Storm 클러스터를 종료시킨다.
 */

// 개발용 클러스터
public class HelloTopologyLocal {
	public static void main(String[] args) {
		TopologyBuilder builder = new TopologyBuilder();
		builder.setSpout("HelloSpout", new HelloSpout(),2);
		builder.setBolt("HelloBolt", new HelloBolt(),4)
						.shuffleGrouping("HelloSpout");
		
		Config conf = new Config();
		conf.setDebug(true);
		
		LocalCluster cluster = new LocalCluster();
		
		cluster.submitTopology("HelloTopologyLocal", conf , builder.createTopology());
		Utils.sleep(10000);
		
		// kill the LearningStormTopology
		cluster.killTopology("HelloTopologyLocal");
		
		// shutdown the storm test cluster
		cluster.shutdown();
	}
}
