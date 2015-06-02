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
    private $pac;

    public function init(){
        parent::init();

        $this->shell = Yii::getPathOfAlias('app').'/commands/shell/wakfu.sh';
        $this->pac = Yii::getPathOfAlias('root').'/pac';
    }

    public function create($port) {
        $result = exec('sudo sh '.$this->shell.' -p '.$port.' -c');
        return empty($result);
    }

    public function remove($port) {
        $result = exec('sudo sh '.$this->shell.' -p '.$port.' -d');
        return empty($result);
    }

    public function view($port) {
        $result = exec('sudo sh '.$this->shell.' -p '.$port.' -v',$output);
        return is_numeric($result) ? $result : -1;
    }

    public function pac($filename, $port) {
        $path = $this->pac.'/'.$filename.'.pac';
        $proxy = 'SOCKS 123.57.74.156:'.$port.'; SOCKS5 123.57.74.156:'.$port;
        $rules = '';
        exec('sudo tsocks gfwlist2pac -f '.$path.' -p "'.$proxy.'" --user-rule '.$rules);
        return Yii::app()->request->getBaseUrl(true).'/pac/'.$filename.'.pac';;
    }
}
