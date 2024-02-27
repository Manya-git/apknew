package com.e10ttech.esimlibrary

import android.annotation.SuppressLint
import android.app.Activity
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import android.telephony.euicc.DownloadableSubscription
import android.telephony.euicc.EuiccInfo
import android.telephony.euicc.EuiccManager
import android.util.Log
import android.widget.Toast
import androidx.annotation.RequiresApi


@SuppressLint("StaticFieldLeak")
object EsimHandler {
    private const val ACTION_DOWNLOAD_SUBSCRIPTION = "download_subscription"
    private const val TAG_ESIM = "TAG_ESIM"
    private lateinit var onEsimDownloadListener: OnEsimDownloadListener
    private lateinit var mContext: Context
    private lateinit var brodIntent: Intent
    private lateinit var activity: Activity

    /**
     *  Intialiase EsimHandler...
     */
    fun init(context: Context,activity: Activity, listener: OnEsimDownloadListener){
        mContext = context
        EsimHandler.activity = activity
        onEsimDownloadListener = listener
        Log.i("init", "init call in handler as well")
    }

    /**
     *  Check Network Connection... return value boolean true/false
     */
    @RequiresApi(Build.VERSION_CODES.M)
    fun isNetworkAvailable(context: Context): Boolean {
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        if (connectivityManager != null) {
            val capabilities = connectivityManager.getNetworkCapabilities(connectivityManager.activeNetwork)
            if (capabilities != null) {
                if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
                    Log.i("Internet", "NetworkCapabilities.TRANSPORT_CELLULAR")
                    return true
                } else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
                    Log.i("Internet", "NetworkCapabilities.TRANSPORT_WIFI")
                    return true
                } else if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)) {
                    Log.i("Internet", "NetworkCapabilities.TRANSPORT_ETHERNET")
                    return true
                }
            }
        }
        return false
    }

    /**
     * Check device suppeort eSIM functionality or not... return boolean true/false
     */
    @RequiresApi(Build.VERSION_CODES.P)
    fun isEsimSupport(context: Context):Boolean {
        var mgr = context.getSystemService(Context.EUICC_SERVICE) as EuiccManager
        if(!mgr.isEnabled){
            Log.e(TAG_ESIM, "isEsimSupport :"+false)
            return  false;
        } else {
            Log.e(TAG_ESIM, "isEsimSupport :"+true)
            return true;
        }
    }

    /**
     * Get Carrie Previliase permission for download and install eSIM from LPA.
     */
    @RequiresApi(Build.VERSION_CODES.P)
    fun getPermission(activity: Activity, context: Context){
        val resolutionIntent = PendingIntent.getBroadcast(context, 0, brodIntent, PendingIntent.FLAG_MUTABLE)
        var mgr = context.getSystemService(Context.EUICC_SERVICE) as EuiccManager
        mgr.startResolutionActivity(activity, 1 /* requestCode */, brodIntent, resolutionIntent)
    }


    /**
     * Give LPA as peramiter and download eSIM.
     */
    @RequiresApi(Build.VERSION_CODES.P)
    fun downloadEsim(code: String) {
        try {
            mContext.registerReceiver(
                receiver,
                IntentFilter(ACTION_DOWNLOAD_SUBSCRIPTION),
                null /* broadcastPermission*/,
                null /* handler */
            )
        } catch (e: Exception) {
            Log.e(TAG_ESIM, "downloadESim : $e")
        }

        var mgr = mContext.getSystemService(Context.EUICC_SERVICE) as EuiccManager
        val intent = Intent(ACTION_DOWNLOAD_SUBSCRIPTION)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            if (!mgr.isEnabled()) {
                Log.e(TAG_ESIM, "EuiccManager is Disable")
            } else {
                Log.e(TAG_ESIM, "EuiccManager is Enable")
            }
        }
        mgr.downloadSubscription(DownloadableSubscription.forActivationCode(code), true, PendingIntent.getBroadcast(mContext, 0, intent, PendingIntent.FLAG_MUTABLE))
    }

    /**
     * Receiver handle whole process for download eSIM.
     */
    private val receiver = object : BroadcastReceiver() {
        @RequiresApi(Build.VERSION_CODES.P)
        override fun onReceive(context: Context?, intent: Intent?) {
            val resultCode = resultCode
            val detailedCode = intent?.getIntExtra(EuiccManager.EXTRA_EMBEDDED_SUBSCRIPTION_DETAILED_CODE, 0)
            brodIntent = intent!!;

            Log.e(TAG_ESIM, "onReceive:brodIntent "+ brodIntent)
            Log.e(TAG_ESIM, "onReceive: detailedCode : $detailedCode")
            Log.e(TAG_ESIM, "onReceive: resultCode : $resultCode")

            if (resultCode == 1) {
                onEsimDownloadListener.onRequest("Request for carrier privileges")
            } else if (resultCode == 0) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    // eSim is active...
                    onEsimDownloadListener.onSuccess("Download is successful and eSim is active")
                    Toast.makeText(context,"Download is successful and eSim is active",Toast.LENGTH_SHORT)
                } else {
                    // eSim is inactive due to the SDK does not support this API level...
                    onEsimDownloadListener.onSuccess("Download is successful, but eSim is inactive due to the SDK does not support this API level")
                }
            } else if (resultCode == 2) {
                onEsimDownloadListener.onFailure("Esim download failed")
            }
        }
    }

    /**
     * Get EID
     */
    @RequiresApi(Build.VERSION_CODES.P)
    fun getEID(context: Context):String{
        var mgr = context.getSystemService(Context.EUICC_SERVICE) as EuiccManager
        var eid=mgr.eid;
        if (eid!=null && eid!=""){
            return eid;
        } else {
            return "";
        }
    }

    private fun onDestroy() {
        mContext.unregisterReceiver(receiver)
    }

}