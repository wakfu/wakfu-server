<?php
/**
 * File: SiteController.php
 * User: daijianhao(toruneko@outlook.com)
 * Date: 15/6/2 21:43
 * Description: 
 */
class SiteController extends Controller{

    public function actionError(){
        if($error=Yii::app()->errorHandler->error)
        {
            if(Yii::app()->request->isAjaxRequest){
                echo $error['message'];
            }else{
                $this->render('error', $error);
            }
        }else{
            $this->render('error');
        }
    }
}