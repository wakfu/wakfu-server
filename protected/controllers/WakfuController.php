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
    private $pacUrl;

    public function init(){
        parent::init();

        $this->shell = Yii::getPathOfAlias('app').'/commands/shell/wakfu.sh';
        $this->client = Yii::getPathOfAlias('app').'/commands/shell/ss-client.sh';
        $this->pacPath = Yii::getPathOfAlias('root').'/pac/';
        $this->pacUrl = Yii::app()->request->getBaseUrl(true).'/pac/';
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

    public function remove($port) {
        $command = array(
            'sudo sh',
            $this->shell,
            '-p '.$port,
            '-d'
        );
        $result = exec(join(' ', $command));
        return empty($result);
    }

    public function open($port){
        $command = array(
            'sudo sh',
            $this->client,
            $port,
            'start'
        );
        $result = exec(join(' ', $command));
        return empty($result);
    }

    public function close($port){
        $command = array(
            'sudo sh',
            $this->client,
            $port,
            'quit'
        );
        $result = exec(join(' ', $command));
        return empty($result);
    }

    public function view($port) {
        $command = array(
            'sudo sh',
            $this->shell,
            '-p '.$port,
            '-v'
        );
        $result = exec(join(' ', $command));
        return is_numeric($result) ? $result : -1;
    }

    public function pac($ip, $port, $rules) {
        $filename = substr(md5($ip.":".$port),8,16).'.pac';
        $path = $this->pacPath.$filename;
        $proxy = 'SOCKS '.$ip.':'.$port.'; SOCKS5 '.$ip.':'.$port;
        $command = array(
            'sudo tsocks gfwlist2pac',
            '-f '.$path,
            '-p "'.$proxy.'"'
        );
        if(!empty($rules)){
            $command[] = '--user-rule '.$this->getUserRulePath($path, $rules);
        }
        exec(join(' ', $command));
        return $this->pacUrl.$filename;
    }

    private function getUserRulePath($path, $rules){
        file_put_contents($path.'.rule',$rules);
        return $path.'.rule';
    }
}
