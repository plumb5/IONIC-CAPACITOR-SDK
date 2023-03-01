package com.plumb5.plugin.plumb5;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;


import androidx.annotation.NonNull;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Retrofit;
import retrofit2.converter.jackson.JacksonConverterFactory;
import retrofit2.http.Body;
import retrofit2.http.FieldMap;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.QueryMap;

import com.chuckerteam.chucker.api.ChuckerInterceptor;

public class ServiceGenerator {
  private static Retrofit retrofit;


  /**
   * Create an instance of Retrofit object
   * */
  public static Retrofit getRetrofitInstance(final String authToken, final String authId,final String basURL) {

    if (retrofit == null) {
      try {
//        ChuckerInterceptor chuckerInterceptor = new ChuckerInterceptor.Builder(P5LifeCycle.getactivity)
//
//                   .maxContentLength(250_000L)
//
//
//                   .alwaysReadResponseBody(true)
//
//
//                   .build();

        OkHttpClient okClient = new OkHttpClient.Builder()
          .addInterceptor(
            new Interceptor() {
              @NonNull
              @Override
              public Response intercept(@NonNull Interceptor.Chain chain) throws IOException {
                Request original = chain.request();

                // Request customization: add request headers
                Request.Builder requestBuilder = original.newBuilder()
                  .header("Content-Type", "application/json")
                  .header("x-apikey", authToken)
                  .header("x-accountid", authId)
                  .method(original.method(), original.body());

                Request request = requestBuilder.build();
                return chain.proceed(request);
              }
            })
//          .addInterceptor(chuckerInterceptor)
          .build();
        retrofit = new retrofit2.Retrofit.Builder()
          .baseUrl(basURL)
          .addConverterFactory(JacksonConverterFactory.create())
          .client(okClient)
          .build();
      } catch (Exception e) {
        Log.d("Service", e.getMessage());

        e.printStackTrace();
      }
    }
    return retrofit;


  }


    public interface API {
        @GET("Mobile/PackageInfo")
        Call<ResponseBody> PackageInfo();

        @POST("Mobile/DeviceRegistration")
        Call<String> DeviceRegistration(@Body Map<String, Object> body);

        @POST("Mobile/ContactDetails")
        Call<ResponseBody> ContactDetails(@Body Map<String, Object> body);

        @POST("Mobile/EventResponses")
        Call<String> EventResponses(@Body Map<String, Object> body);

        @POST("/Mobile/Tracking")
        Call<String> Tracking(@Body Map<String, Object> body);

        @POST("/Mobile/PushResponses")
        Call<ResponseBody> PushResponse(@Body Map<String, Object> body);

        @GET("/Mobile/InApppDisplaySettingsDetails")
        Call<ResponseBody> InAppDetails(@QueryMap Map<String, Object> params);
    }

}

class RetrofitInstance {

    private static Retrofit retrofit;


    /**
     * Create an instance of Retrofit object
     * */
    public static Retrofit getRetrofitInstance(final String authToken, final String authId,final String basURL) {

            if (retrofit == null) {
                try {

                    OkHttpClient okClient = new OkHttpClient.Builder()
                            .addInterceptor(
                                    new Interceptor() {
                                        @NonNull
                                        @Override
                                        public Response intercept(@NonNull Interceptor.Chain chain) throws IOException {
                                            Request original = chain.request();

                                            // Request customization: add request headers
                                            Request.Builder requestBuilder = original.newBuilder()
                                                    .header("Content-Type", "application/json")
                                                    .header("x-apikey", authToken)
                                                    .header("x-accountid", authId)
                                                    .method(original.method(), original.body());

                                            Request request = requestBuilder.build();
                                            return chain.proceed(request);
                                        }
                                    })

                            .build();
                    retrofit = new retrofit2.Retrofit.Builder()
                            .baseUrl(basURL)
                            .addConverterFactory(JacksonConverterFactory.create())
                            .client(okClient)
                            .build();
                } catch (Exception e) {
                    Log.d("Service", e.getMessage());

                    e.printStackTrace();
                }
            }
            return retrofit;


        }
    }








