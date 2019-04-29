<?php

class IndexController extends ControllerBase
{
    public function beforeExecuteRoute($dispatcher)
    {
        if(true){
            echo 'loginout';
            exit;
        }
        echo 'before';
    }
    public function indexAction()
    {
        echo '<h1>ok</h1>';
    }

    public function testAction()
    {
        echo 'test';
    }
}

