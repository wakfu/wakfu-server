<?php
use \net\toruneko\wakfu\interfaces\WakfuServiceIf;
/**
 * File: WakfuController.php
 * User: daijianhao(toruneko@outlook.com)
 * Date: 15/6/2 21:13
 * Description: 
 */
class WakfuController extends TController implements WakfuServiceIf{

    private $shell;
    private $client;
    private $pacPath;

    public function init(){
        parent::init();

        $this->shell = Yii::getPathOfAlias('app').'/commands/shell/wakfu.sh';
        $this->client = Yii::getPathOfAlias('app').'/commands/shell/ss-client.sh';
        $this->pacPath = Yii::getPathOfAlias('app').'/data/pac/';
    }

    public function create($ip, $port) {
        $command = array(
            'sudo sh',
            $this->shell,
            '-s '.$ip,
            '-p '.$port,
            '-c'
        );
        $result = exec(join(' ', $command));
        return empty($result);
    }

    public function remove($ip, $port) {
        $command = array(
            'sudo sh',
            $this->shell,
            '-p '.$port,
            '-d'
        );
        $result = exec(join(' ', $command));
        return empty($result);
    }

    public function open($ip, $port){
        $server = array('23.252.107.210','138.128.210.30');
        $command = array(
            'sudo sh',
            $this->client,
            '-s '.$server[mt_rand(0,1)],
            '-p '.$port,
            '-m start'
        );
        $result = exec(join(' ', $command));
        return empty($result);
    }

    public function close($ip, $port){
        $command = array(
            'sudo sh',
            $this->client,
            '-p '.$port,
            '-m quit'
        );
        $result = exec(join(' ', $command));
        return empty($result);
    }

    public function view($ip, $port) {
        $command = array(
            'sudo sh',
            $this->shell,
            '-p '.$port,
            '-v'
        );
        $result = exec(join(' ', $command));
        return $result;
    }

    public function pac($ip, $port, $rules) {
        $filename = substr(md5($ip.":".$port),8,16).'.pac';
        $path = $this->pacPath.$filename;
        $proxy = 'SOCKS5 '.$ip.':'.$port;
        $command = array(
            'sudo tsocks gfwlist2pac',
            '-f '.$path,
            '-p "'.$proxy.'"'
        );
        if(!empty($rules)){
            $command[] = '--user-rule '.$this->getUserRulePath($path, $rules);
        }
        exec(join(' ', $command));
        return file_get_contents($path);
    }

    private function getUserRulePath($path, $rules){
        file_put_contents($path.'.rule',$rules);
        return $path.'.rule';
    }
}
