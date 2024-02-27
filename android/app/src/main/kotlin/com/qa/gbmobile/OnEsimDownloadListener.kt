package com.e10ttech.esimlibrary

interface OnEsimDownloadListener {
    fun onSuccess(result: String)

    fun onRequest(result: String)

    fun onFailure(result: String)
}