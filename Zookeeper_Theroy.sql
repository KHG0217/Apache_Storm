Zookeeper 

	1.Zookeeper 란?
		-> 분산 처리 환경에서 사용 가능 한 데이터 저장소
			* 활용분야
				- 서버 간의 정보 공유(설정관리)
				- 서버 투입 제거 시 이벤트 처리(클러스터 관리)
				- 리더 선출
				- 서버 모니터링
				- 분산 락 처리
				- 장애 상황 판단
			
			1. Zookeeper 데이터 모델
				- 일반적인 파일 시스템과 비슷
				- 각각의 디렉터리 노드를 znode라고 명명 (변경 X, 스페이스 X)
				- 노드는 영구(Persistent) / 임시(Ephemeral) 노드가 존재
					->  Persistent 노드 - 세션 종료시 삭제 x 데이터 유지
						Ephemeral 노드 - 세션이 유효한 동안 그 노드의 데이터 유효
						Sequential 노드 - 시퀸스 넘버가 자동으로 append
				* 그림 1 참고
			
			2. Zookeeper 서버 구성도
				- 각각의 서버는 다른 서버의 정보를 가지고 있음
				- client는 하나의 서버랑 연결
					-> 커넥션을 유지, 만약 서버와 연결이 끊어지면 다른 서버랑 통신
				
				- Zookeeper 서버는 Leader와 Follower로 구성
					-> 자동으로 Leader 선정 & 모든 데이터 저장을 주도
					-> Client에서 Server(Follower)로 데이터 저장을 시도할 때
					   Server(Follower) -> Server(Leader) -> Server(Follower) 로 데이터 전달
					   팔로어 중 과반수의 팔로워로 부터 쓸 수 있다는 응답을 받으면 쓰도록 지시
					   모든 서버에 동일한 데이터가 저장된 후 클라이언트에게 응답(동기 방식)
					-> 서버 간의 데이터 불일치가 발생하면 데이터 보정이 필요
					   (과반수 룰을 적용하기 때문에 홀수로 구성하는 것이 데이터 정합성 측면에서 유리)
			* 그림 2 참고
			
			3. Zookeepr 데이터저장구조
				-> Zookeeper는 파일시스템에 저장되는 파일 하나하나를 znode라고 부른다.
				-> Zookeeper은 data를 메모리에 올린다.
				
				 * ZNode의 특징
					- hierarchy
						-> znode는 unix-like 시스템에서 쓰이는 file system처럼 node간의 hierarchy namespace를
						가지고 , 이를 /을 이용하여 구분한다.
						
						->  일반적인 fire system과 다른 부분이 있다.
							ZooKeeper는 fire 과 directory의 구분 없이 znode라는 것 하나만 제공한다.
							즉, directory에도 내용을 적을 수 있는, directory와 file간의 구분이 없는 file system 이라는 것
							
						-> namespace hierarchy를 가지기 때문에 관련 있는 일들을 눈에 보이는 하나로 묶어 관리할 수 있다.
						
				2. size 제한
					->  ZooKeeper는 모든 data를 메모리에 저장한다.
						data를 메모리에 저장하기 때문에 jvm의 heap memory를 모든 znode를 올릴 수 있는 충분한 크기로 만들어야 한다.
						znode에는 조정에 필요한 metadata만을 저장하는 것이 기본적인 사용법
						znode 자체도 크기가 작은 data를 저장할 것이라고 가정하고 구현되어 있기 때문에 각 zonde의 크기는 1MB이다.
						
				3. Recovery
					1. ZooKeeper설정파일에 dataDir
						* ZooKeeper 모든 data를 메모리에 올리는데 dataDir은 무엇을 위한 것?
							->	Zookeeper의 recovery를 위해 사용됨
								Zookeeper는 모든 data를 메모리에 들고 있기 때문에, 서버가 종료되었다가 재 시작했을 때 자료를 보존할 수 없다.
								이때, 원래의 자료를 복구할 수 있는 것을 보장하기 위하여 ZooKeeper은 모든 transaction log를 dataDir에 저장한다.
								
							->  Zookeeper를 재 시작하면 dataDir에서 'transaction log'를 읽어와서 모든 트랜잭션을 다시 실행하여 data를 복구한다.
								하지만 언제나 transaction log만을 이용하여 자료를 복구한다면, 자료를 복구하는데 시간이 걸리고, 자료의 양이 커짐
								이를 해결하기 위해 transaction log가 일정 이상 되면, transaction log로 만들 수 있는 data를 하드에 저장하고
								transaction log를 지운다. 이 data를 'snapshot'이라고 한다.
								
				4. ZNode의 종류
				
					->  znode를 생성할 때 2 종류의 옵션이 있다.
						1. 'life cycle에 관한 option'으로 persistent or ephemeral인지 설정
						2. 'znode의 uniqueness에 관한 option'으로 sequential node인지 아닌지를 설정
						
							1. Persistent mode 와 Ephemeral mode
								->	Persistent mode와 Ephemeral mode는 znode 의 life cycle에 관한 설정,
									모든 zonde는 persistent 하거나 ephemeral(임시) 하지만, 동시에 둘 다 일수는 없다. 
									
									* 'Persistent mode'는 우리가 생각하는 일반적인 file과 같다.
									
									* 'Ephemeral mode'는 생성된 znode는 ZooKeeper서버와 znode를 생성하도록 요청한 클라이언트
									사이의 connection이 종료되면 자동으로 지워진다. 이런 특성을 이용하여 lock나 leader election을 구현한다.
									
							2. Sequence mode
								->  'Sequence mode' znode의 uniqueness를 보장하기 위한 것이다.
									Sequence mode로 만들어진 znode는 주어진 이름 뒤에 int범위의 10개의 숫자가 postfix로 붙는다.
									이 숫자는 atomic하게 증가하여 같은 이름으로 만든 node라고 해도 서로 다른 이름의 znode로 만들어 준다.
									
								->  'ephemeral mode'와 'persistent mode'둘 다 sequence node로 만들 수 있다.
									하지만 동시에 사용하면 node를 생성하는 것은 문제가 생길 수 있다. ZooKeeper서버와 ZooKeeper클라이언트는
									비동기적으로 동작할 뿐 아니라 둘 사이의 connection은 빈번하게 끊길 수 있다.
									
									ephemeral + sequence node를 생성하라고 요청하였을 때 성공인지 실패인지 답이 오지 않고 timeout이 발생할 수 있다.
									
							* 정리 ! ZNode종류 3개 - Persisten Znodes[기본], Ephemeral Znodes[임시], Sequential Znodes[연속]
									
				5. ACL(Access Control List)
				
					->	znode는 ACL을 이용하여 각가의 znode에 접근권한을 설정할 수 있다.
					
					->	하지만 unix-like 파일시스템과 다르게 znode에는 user/group/other 이라는 개념이 존재하지 않는다.
						대신 permission 과 scheme가 있다. 
						이때 조심할건 zcode의 ACL은 자기 자신의 ACL이고, 자식들에게 recursive하게 적용되지 않는다는 것이다.
						즉, /some-done에 권한을 설정해도 /some-node/child에는 권한이 설정되지 않는다는 것이다.
						
				6. ACL Permissions
				
					->	ZooKeeper에서의 권한은 unix-like 파일시스템의 권한과 크게 다를 것은 없다.
						특정 권한들에 대해 allow flag가 있어서 이것이 어떻게 설정되었는가에 따라서
						해당 권한을 실행시킬 수 있는지가 결정된다.
						
					->	ZooKeeper에서 설정할 수 있는 ACL의 종류는 아래 5가지 이다.
					
							1. CREATE: 해당 znode의 자식 node를 만들 수 있는 권한
							2. READ: 해당 znode에서 data를 읽고와서 그 자식들의 목록을 읽을 수 있는 권한
							3. WRITE: 해당 znode에 값을 쓸 수 있는 권한
							4. DELETE: 해당 znode의 자식들을 지울 수 있는 권한
							5. ADMIN: 해당 znode에 권한을 설정할 수 있는 권한
							
							* unix-like file system과 다른 부분이 2가지 있다.
								1. create와 delete라는 권한이 존재하여 자식 node를 생성하고 삭제할 수 있는 권한이 있다.
								2. ZooKeeper에서는 모든 znode가 directory이기도 하고, file이기도 해서 자기 자신에 대한 쓰기 권한과
								   자신에 대한 쓰기 권한과 자식 node에 대한 생성/삭제 권한을 같이 쓸 수 없다.
								   
				7. Schemes
				
					->  ZooKeeper는 unix-like 시스템과 다르게 각 znode에 user/group/others라는 개념이 존재하지 않는다.
						대신 scheme이라는 것을 이용하여 권한을 구분하게 되어있다.
						built in으로 제공되는 설정할 수 있는 scheme은 아래와 같이 4가지가 있다.
						
							1. WORLD: 모든 요청 허락
							2. AUTH: authenticated된 session에서 들어오는 요청에 대해서만 허락하는 것
							3. DIGSET: username과 password를 보내서 이를 이용하여 만든 MD5 hash값이 같은 요청에 대해서만 처리
							4. IP: 해당 IP에서의 요청만을 처리하도록 하는 것

				8. Stat
					->	ZNode는 node와 node의 data에 관한 여러 정보를 들고 있고, 이것을 stat라고 부른다.
					
						1. czxid : znode를 생성한 트랜잭션의 id
						2. mzxid : znode를 마지막으로 수정 트랜잭션의 id
						3. ctime : znode가 생성됐을 때의 시스템 시간
						4. mtime : znode가 마지막으로 변경되었을 때의 시스템 시간
						5. version : znode가 변경된 횟수
						6. cversion : znode의 자식 node를 수정한 횟수
						7. aversion : ACL 정책을 수정한 횟수
						8. ephemeralOwner : 임시 노드인지에 대한 flag
						9. dataLength : data의 길이
						10. numChildren : 자식 node의 수
						
						
				9. Shell 명렁어
					1. 실행: zookeeper폴더 경로 /bin/zkServer.sh start
					2. 종료: zookeeper폴더 경로/bin/zkServer.sh stop
					3. 상태확인: zookeeper폴더 경로/bin/zkServer.sh status
					4. CLI접속: zookeeper폴더 경로/bin/zkCil.sh
					
						1.CLI 접속 Zookeepr 명령어
							
							1. znode생성
								->	기본적으론 영구적 
										
								create -[options] /[znode-name] [znode-data]
								ex) Persistent: create /znode my_data
									Ephemeral: create -e /eznode my_data
									Sequential: create -s /sznode my_data
								->  각 znode에는 하위 znode가 있을 수 있다.
							   		하위 znode를 작성하기위한 명령 구문
							   
							   	    create /[parent_znode]/[child_znode] [child_znode_data]
							   	    
							2. znode 읽기
								get /[znode_name]
								ex) get /znode
								
							3. znode 데이터 설정
								set /[znode_name] [new_data]								
								ex) set /znode my_data_mod
									
							4. znode 삭제
								delete /[znode_name] 
								ex) delete /znode
								
							6. znode 목록
								ls [znode_name]
								ex) ls / - 전체목록
									ls /znode
									
				10. Zookeeper 스냅샷 및 트랜잭션 로그 삭제
					-> 	znode들에 변화가 생길 때 마다 Zookeeper은 이 변화된 내용을 스냅샷과 트랜잭션에 로그추가
						스냅샷과 트랜잭션 로그의 크기가 점점 커지면 현재 상태의 znode값으로 새로운 스냅샷과 트랜잭션 로그 파일 생성
						스냅샷이 생성되는 동안 들어오는 값의 변화에 대해서는 이전 로그 파일에 그대로 추가함
						이러한 이유로 어떤 트랜잭션은 새로생긴 스냅샷보다 더 오래된 예전 스냅샷에 최신 정보가 있을 수 있다.
						
						* 자동으로 지우기 
							-> conf -> zoo.cfg 파일 수정 ->아래코드 추가
							autopurge.snapRetainCount=3 최신 스냅샷3개 남기기
							autopurge.purgeInterval=24 주기 24시간
						
						
								
						
						
						
						
						
						
						