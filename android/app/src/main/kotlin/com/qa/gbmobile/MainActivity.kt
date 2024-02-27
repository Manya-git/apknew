package com.trial.gbmobile

import android.os.Build
import android.os.Build.VERSION_CODES
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import com.e10ttech.esimlibrary.EsimHandler
import com.e10ttech.esimlibrary.OnEsimDownloadListener
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity(), OnEsimDownloadListener {

    private val CHANNEL = "gb.flutter.dev"

    private var myResult: MethodChannel.Result? = null

    @RequiresApi(VERSION_CODES.P)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            myResult = result;
            if (call.method.equals("initcall")) {
                Log.e("TAG", "Init metod call! ")
                EsimHandler.init(this,this,this)
            } else if (call.method.equals("internet")) {
                var isNetwrok= EsimHandler.isNetworkAvailable(applicationContext)
                Log.e("TAG_E", "isNetworkAvailable :"+isNetwrok)
            } else if (call.method.equals("esimsupport")) {
                var isSupport= EsimHandler.isEsimSupport(applicationContext)
                Log.e("TAG_E", "isEsimSupport :"+isSupport)
            } else if (call.method.equals("download")) {
                val LPAData: String? = call.argument("LPA")
                val tempLPA = LPAData!!.split(":")
                var finalLPA=tempLPA[1]
                Log.e("TAG_E", "LPA :"+LPAData)
                Log.e("TAG_E", "finalLPA :"+finalLPA)
                EsimHandler.downloadEsim(finalLPA)
                Log.e("TAG_E", "download :")
            } else if (call.method.equals("eid")) {
                Log.e("TAG_E", "eid :")
                val eid=EsimHandler.getEID(applicationContext)
                Log.e("TAG_E", "eid = :"+eid);
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onSuccess(result: String) {
        Log.e("TAG", "onSuccess: ")
        Log.e("TAG", "onSuccess: "+result)
        myResult!!.success("SUCCESS")
//        Toast.makeText(getApplicationContext(),"Successful installation & activation of eSIM", Toast.LENGTH_SHORT).show();
    }

    override fun onRequest(result: String) {
        Log.e("TAG", "onRequest: " )
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            EsimHandler.getPermission(this,applicationContext)
        }
    }

    override fun onFailure(result: String) {
        Log.e("TAG", "onFailure: " )
        myResult!!.success("FAIL")
//        Toast.makeText(getApplicationContext(),"Failed to install & activate eSIM", Toast.LENGTH_SHORT).show();
    }

}
