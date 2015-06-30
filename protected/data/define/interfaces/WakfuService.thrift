namespace php net.toruneko.wakfu.interfaces

service WakfuService
{
    bool open(1:string ip, 2:i32 port),
    bool close(1:string ip, 2:i32 port),
    bool create(1:string ip, 2:i32 port),
    bool remove(1:string ip, 2:i32 port),
    i64 view(1:string ip, 2:i32 port),
    map<i32, i64> multiView(1:string ip, 2:list<i32> port),
    string pac(1:string ip, 2:i32 port, 3:string rules),
}