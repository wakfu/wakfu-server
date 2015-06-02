namespace php net.toruneko.wakfu.interfaces

service WakfuService
{
    bool create(1:i32 port),
    bool remove(1:i32 port),
    i64 view(1:i32 port),
    string pac(1:i32 port),
}