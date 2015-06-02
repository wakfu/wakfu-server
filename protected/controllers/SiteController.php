<?php
/**
 * File: SiteController.php
 * User: daijianhao(toruneko@outlook.com)
 * Date: 15/6/2 21:43
 * Description: 
 */
class SiteController extends CController{

    public function actionError(){
        if($error=Yii::app()->errorHandler->error)
        {
            echo $error['message'];
        }
    }
}