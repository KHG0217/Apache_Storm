package storm;

import backtype.storm.Config;
import backtype.storm.StormSubmitter;
import backtype.storm.generated.AlreadyAliveException;
import backtype.storm.generated.InvalidTopologyException;
import backtype.storm.topology.TopologyBuilder;
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
 *  	8. LocalCluster을 생성하지 않고, 기동중인 클러스터에 HelloTopology를 Submit하도록 한다.
 *  
 */

// 운영용 클러스터
public class HelloTopology {
    public static void main(String args[]){

        TopologyBuilder builder = new TopologyBuilder();

        builder.setSpout("HelloSpout", new HelloSpout(),2);

        builder.setBolt("HelloBolt", new HelloBolt(),4).shuffleGrouping("HelloSpout");

       

        Config conf = new Config();

        // Submit topology to cluster

        try{

                StormSubmitter.submitTopology(args[0], conf, builder.createTopology());

        }catch(AlreadyAliveException ae){

                System.out.println(ae);

        }catch(InvalidTopologyException ie){

                System.out.println(ie);

        }

       

 }



}
