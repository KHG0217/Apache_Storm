Apache Storm - 실시간 데이터 처리를 위한 시스템이다.

	1. 스트리밍 처리의 대한 개념
		비유 - 데이터가 흘러가는 강 같은 의미
		ex) 트위터에서 생성되는 데이터 피드들은 일종의 데이터 스트림이다.
		시간이 지남에 따라 끊임없이 데이터 들이 생성된다.

		-> 신용카드 트렌젝션, 전자 상거래 사이트 구매 트렌젝션등 
		이러한 데이터는 시간을 축으로 하여 계속 생성되는 데이터이다.
		
	2. 스트리밍 데이터를 사용하는 것
		1. 트위터 데이터 피드 스트림을 모니터링하면서, 스마트폰과 관련된 키워드가 나오면
		관련 스트림만을 수집하여, 각사별로 피드의 내용이 긍정적인지 부정적인지를 판단하는
		시스템이 있다고 가정
		
			1. 스마톤 관련 데이터 스트림 수집
			2. 그중 A사 언급피드와 B사 언급 피드 분리
			3. 각 피드에 대해 긍정인지 부정인지 판단
			4. 그후 각 반응에 대해서 카운트 , 시계열그래프로 대쉬보드 표현

	3. 데이터 스트림 처리를 이루는 기술들
		1.  스트리밍 처리
			-> 각각의 단계별로 처리하는 워크 플로우 기능이 필요하다
			이러한 프레임웍은 아파치스톰이 대표적이고, 아파치 스파크도 많이 사용된다.
		
		2. 대용량 분산 큐
			->대용량으로 여러 경로를 통해 들어오는 데이터를 수집하기 위한 터널필요
			비동기 처리를 위한 큐가 적절, 이를 위해서는 kafka와 같은 대용량
			분산 큐 솔루션이 적절하다.
				
		3. 머신러닝
			-> 패턴분석, 데이터를 학습해서 패턴을 분석하는 머신러닝 기술 필요
			Apache Mahout, Microsoft Azure ML(머신러닝), SparkML 등이 있다

		4. 이벤트처리	
			->특정 조건에 대해 이벤트 발생시키는 처리를
			CEP(Complex Event Processing)라고 부르고, 이를 구현한 아키텍쳐를
			EDV (Event Driven Archiectute)라고 한다.

			-> 이러한 이벤트 퍼리 프레임웍으로는 JBoss DRool이나, Esper와 같은
			프레임웍이 있다.

	4. Storm 클러스터의 기본 구조
		1. 클러스터의 노드 구성
			1. NimBus
				-> NimBus는 마스터 노드로 주요정보를 가지고 있다.
				-> 프로그래밍이된 토폴로지를 Supervisor 노드로 배포한다.
				-> 중앙 컨트롤러로 생각하면 된다.
				-> Storm에서는 중앙의 하나의 Nimbus 노드만을 유지한다.

			2. Supervisor
				-> Supervisor 노드는 실제 워커노드로 Nimbus로 부터 프로그램을
				배포 받아 탑재하고, NimBus로 부터 배경된 작업을 실행하는 역활을 한다.
				-> 하나의 클러스터에는 여러개의 Supervisor 노드를 가질 수 있다.
				-> 이를 통해서 여러개의 서버를 통해 작업을 분산 처리할 수 있다.

			3. Zookeeper
				-> 여러개의 Supervisor를 관리하기위해 Zookeeper를 통해서 각 노드의 
				상태를 모니터링 하고, 작업의 상태들을 공유한다.

				*Zookeeper는 아파치 오픈소스 프로젝트의 하나로, 분산 클러스터의
				노드들의 상태를 체크하고, 공유 정보를 관리하기 위한 분산 코디네이터 솔류				
				션이다.

	5. Storm의 특징
		-> Storm을 실시간 스트리밍을 처리하기 위한 서버이자 프레임웍이다.
		
			1. 확장성
				-> 클러스터링 기능을 이용해서 수평으로 확장이 가능하다.
				-> 그래서 많은 데이터를 다루어야하는 빅데이터나 스트림 서비스에서도 가능하다
				
			2. 장애 대응성
				-> Zookeeper를 통해서 전체 클러스터의 운영 상태를 감지하며, 특정 노드가 장애가 나더라도 진행가능하다.
				-> 장애가 난 노드에 할당된 작업은 다른 노드에 할당처리하고, 장애노드는 복구 처리를 자동으로 수행한다.

			3. 메시지 전달 보장
				-> 장애가 있건 없건 유실 없이 최소한 한번 메세지가 처리될 수 있게 지원한다.
				-> 1번 이상 같은 메세지가 중복 처리될수도 있지만 Trident를 통해서 Strom을 확장하면, 중복을 해결한다.

			4. 쉬운 배포
				-> 설치 후 웹 기반의 모니터링 콘솔을 제공하기 때문에 시스템의 상태를 쉽게 모니터링하고 운영하는데 도움이 된다.

			5. 여러 프로그래밍 언어 지원
				-> Storm은 기본적으로 JVM위에서 동작하나, JAVA를 사용하지 않는 경우 stdin/stout를 통해서 주고받음으로써
				Ruby,Python,JS,Perl등 다양한 언어를 사용할 수 있다.

			6. 다양한 시스템 연계
				-> 다양한 다른 솔루션과 통합이 가능하다.
				-> 데이터 수집 부분에서는 Kestrel, RabbitMQ, Kafka, JMS 프로토콜, mazon Kinesis 등 연동 가능
				-> 다양한 데이터 베이스 RDBMS, Cassandra, MongoDB등 쉽게 연계가능
				-> 이벤트 처리 분야 Drols, Elastic Searcg, node.js등 다양한 솔루션과 연결가능

			7. 오픈소스

	6. Storm의 기본 개념
		1. Spout와 Bolt

			1. Spout
				-> Storm 클러스터로 데이터를 읽어들이는 데이터 소스이다.
				-> 외부 로그파일이나, 트위터 타임 피드와 같이 데이터 스트림, 큐등에서 데이터를 읽어들인다.
				-> 이렇게 읽어들인 데이터를 다른 Bolt로 전달한다.
				
				* 중요 메서드
					1. open()
						-> 이 메서드는 Spout이 처음 초기화 될때 한번 호출되는 메서드, 데이터 소스로부터 연결을 초기화하는 역활

					2. nextTuple()
						-> 이 메서드는 데이터 스트림 하나를 읽고 나서, 다음 데이터 스트림을 읽을 때 호출되는 메서드

					3. ack(Object msgid)
						-> 데이터 스트림이 성공적으로 처리되었을 때 호출, 성공 처리된 메세지를 지우는 등 성공 처리에 대한 후처리를 구현

					4. fail(Obkect msgid)
						-> 데이터 스트림이 Storm 토폴로지를 수행하던중 에러가 나거나 타임아웃등이 걸렸을때 호출
						-> 사용자가 에러에 대한 처리로직을 명시해야하고, 흔히 재처리 로직을 구현하거나 에러 로깅등을 처리한다.

			2. Bolt
				-> 읽어들인 데이터를 처리하는 함수
				-> 입력값으로 데이터 스트림을 받고, 그 데이터를 내부의 비지니스 로직에 따라 가공한 후 데이터 스트림으로 다른 Bolt를 넘겨주거나 종료

				* 중요 메서드
					1. prepare(Map stormConf, TopologyContext context, OutputCollector collector)
						-> Bolit 객체가 생성될때 한번 호출, 각종 설정 정보나 컨텍스트등 초기 설정에 필요한 부분을 세팅하게 된다.

					2. execute(Tuple input)
						-> 가장 필수적인 메서드, Bolt에 들어온 메세지를 처리하는 로직, 다음 Bolt로 메세지를 전달하기도 한다.

			* Storm 클리서트너내에는 여러개의 Spout와 Bolt가 존재하게 된다.
			* 그림 1 참고


			3. Topology
				-> 이렇게 여러 개의 Spout와 Bolt간의 연관 관계를 정의해서 데이터 흐름을 정의하는 것이 토폴로지
				-> 데이터가 어디로 들어와서 어디로 나가는지를 정의
			* 그림 2 참고

			4. Stream 과 Tuple
				1. Storm - Spout와 Bolt간 또는 Bolt간을 이동하는 데이터들의 집합을 이야기한다.
				2. Tuple - 각각의 Stream은 하나의 Tuple로 이루어 지는데, 각 Tuple 은 "키"와 "값" 형태로 정의된다.
			* 그림 3 참고	
	
	7. Storm의 병렬 처리를 이해하기위한 개념
		-> 병렬처리를 이해하기 위해서는 몇가지 개념을 정리해야 한다. 
		-> Node,Worker,Exectutor,Task
		
			1. Node
				-> 물리적인 서버, Nimbus나 Supervisor 프로세스가 가동되는 물리적인 서버이다.
				-> Nimbus는 전체 노드에 하나 프로세스만 가동하며, Supervisor은 일반적으로 하나의 노드에 하나만 기동한다.
				-> 여러대를 기동시킬 수 도 있지만, Superviosr의 역활 자체가 해당 노드를 관리하는 역활이기 때문에,
				-> 하나의 노드에 여러개의 Supervisor를 기동할 필요는 없다.
				
			2. Worker (프로세스)
				-> Supervisor가 기동되어 있는 노드에서 기동되는 자바 프로세스로 실제로 Spout와 Bolt를 실행하는 역활을 한다.
				
			3. Executor (쓰레드)
				-> Worker내에서 수행되는 하나의 자바 쓰레드를 지칭한다.
				
			4. Task
				-> Task는 Bolt나 Spout의 객체를 지칭한다.
				이 Task는 Executor에 의해서 수행된다.
			* 그림 4 참고
			
			* 슬레이브 노드에 Supervisor 프로세스가 하나씩 떠있고,
			conf/storm.yaml 정의된 설정에따라 worker 프로세스를 띄운다.
			.supervisor.slots.ports에 각 Worker가 사용할 TCP 포트를 정해주면 됨
			* 그림 5 참고
			
			* 쓰레드수와 쓰레드에서 돌아가는 객체(Task)수에 따라서 성능이 많이 차이날것
			
			
	8. Task간에 라우팅
	* 라우팅 네트워크에서 경로를 선택하는 프로세스, 미리 정해진 규칙을 사용하여 최상의 경로를 선택하는 프로세스
		
		1. Shuffling
			-> 가장 간단한 라우팅방법
			-> Bolt 내에 있는 Task가 또 다른 Bolt에 있는 Task중 임의로 라우팅하는 방식
			
		2. Field
			-> 보내고자 하는 데이터의 특정 필드에 있는 값을 기준으로 라우팅하는 방식
			-> 지정한 필드의 값을 가지고 해쉬를 계산해서 해쉬에 따라 Bolt에있는 Task로 라우팅하는 방식
			
			ex)
			Bolt B에 Task가 3개 있다고 가정할때,
			나이라는 필드로 "Field Grouping"을 한다면,
			나이/3으로 나눈 나머지 값에 따라서 Task A,b,C로 라우팅하는 방식이다.
			(이해가 쉽게 하기위해 나눗셈으로 설명했지만 비슷한 원리로 해쉬를 계산하여 라우팅한다.)
			Bolt에서 로컬 캐쉬를 사용하거나 할때, 같은 해쉬의 데이터가 같은 Task로 라우팅 되게 해서
			캐쉬 히트율을 높이는 것등에 유용하게 사용될 수 있다.
			*그림 6 참고
			
		3. Global
			-> Global 그룹핑은 모으는 개념이다. Bolt A의 어느 Task에서 메세지를 보내더라도
			항상 일정한 Bolt Task로 라우팅이 되는 방식
			분산해서 연산한 값을 모두 모아서 합산하는 등에 사용될 수 있다.
			
		4. ALL
			-> 브로드 캐스트 개념으로 Bolt A의 하나의 Task가 메세지를 전송하면
			Bolt B의 모든 Task가 메세지를 받는 형태
			
		5. Direct
			-> Task의 Index로 타겟을 지정하여 명시적으로 지정하는 방식이다.
			
		6. Custom
			-> Custom 그룹핑은 라우팅 로직을 개발자가 직접 작성해서 넣는 방식이다.
			
		7. Local or Shuffle
			-> 기본적인 동작 방식은 Shuffle와 다르지 않으나,
			Bolt A에서 Bolt B의 Task로 라우팅을 할때, Bolt A에서 메세지를 보내는 Task와
			같은 JVM 인스턴스(Worker)에 Bolt B의 Task가 있을 경우, 같은 JVM 인스턴스에
			있는 Task로 우선 라우팅을 한다.
			-> 이는 네트워크를 이용한 리모트 호출을 줄이기 위한 방법이다.
			
			-> 그러면 Bolt의 Task들은 각 Worker에 어떻게 배치 될것인가에 대한 질문이 올 수있는데,
			이렇게 Task를 Worker에 배치하는 행위를 스케줄러라고 하고, 배치를 하는 주체를 Scheduler라고 한다.
			
			
	
	
	
	
			