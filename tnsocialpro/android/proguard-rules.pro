# This file is no longer maintained and is not used by new (2.2+) versions of the
# Android plugin for Gradle. Instead, the Android plugin for Gradle generates the
# default rules at build time and stores them in the build directory.
# SDK中的该文件已经不再维护，从Gradle2.2+版本后，gradle插件会自动生成这个默认配置文件，位置位于<项目根目录>/build/intermediates/proguard-files

# 混淆时不使用大小写混合，混淆后的类名为小写
-dontusemixedcaseclassnames

# 不跳过非公共的库的类
-dontskipnonpubliclibraryclasses

# 混淆后生成映射文件，map 类名->转化后类名的映射
-verbose

# Optimization is turned off by default. Dex does not like code run
# through the ProGuard optimize and preverify steps (and performs some
# of these optimizations on its own).
# 优化默认关闭，Dex不喜欢通过ProGuard的优化和预处理操作
-dontoptimize
-dontpreverify

# Note that if you want to enable optimization, you cannot just
# include optimization flags in your own project configuration file;
# instead you will need to point to the
# "proguard-android-optimize.txt" file instead of this one from your
# project.properties file.

# 保护代码中的Annotation不被混淆，这在JSON实体映射非常重要，如GSON
-keepattributes *Annotation*
-keep public class com.google.vending.licensing.ILicensingService
-keep public class com.android.vending.licensing.ILicensingService

# For native methods, see http://proguard.sourceforge.net/manual/examples.html#native
# 保留所有的地方native方法不被混淆
-keepclasseswithmembernames class * {
    native <methods>;
}

# keep setters in Views so that animations can still work.
# see http://proguard.sourceforge.net/manual/examples.html#beans
# 不混淆View中的setXxx()和getXxx()方法，以保证熟悉动画能正常工作
-keepclassmembers public class * extends android.view.View {
   void set*(***);
   *** get*();
}

# We want to keep methods in Activity that could be used in the XML attribute onClick
# 不混淆Activity中参数是View的方法，保证xml绑定的点击事件可以正常工作
-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}

# For enumeration classes, see http://proguard.sourceforge.net/manual/examples.html#enumerations
# 不混淆枚举类中的value()和valueOf()方法
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# 不混淆Parcelable实现类中的CREATOR字段，以保证Parcelable机制正常工作
-keepclassmembers class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator CREATOR;
}

# 不混淆R文件中的所有静态字段，以保证正确找到每个资源id
-keepclassmembers class **.R$* {
    public static <fields>;
}

# The support library contains references to newer platform versions.
# Don't warn about those in case this app is linking against an older
# platform version.  We know about them, and they are safe.
# 不对android.support包下的代码警告。(如果打包的版本低于support包下某些类的使用版本，会出现警告)
-dontwarn android.support.**

# Understand the @Keep support annotation.
# 不混淆Keep类
-keep class android.support.annotation.Keep

# 不混淆使用了注解的类和类成员
-keep @android.support.annotation.Keep class * {*;}

# 如果类中有使用了注解的方法，则不混淆类和类成员
-keepclasseswithmembers class * {
    @android.support.annotation.Keep <methods>;
}

# 如果类中有使用了注解的字段，则不混淆类和类成员
-keepclasseswithmembers class * {
    @android.support.annotation.Keep <fields>;
}

# 如果类中有使用了注解的构造函数，则不混淆类和类成员
-keepclasseswithmembers class * {
    @android.support.annotation.Keep <init>(...);
}

-dontwarn com.xiaomi.push.**
-keep class com.xiaomi.push.** { *; }
-ignorewarnings
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keep class com.hianalytics.android.**{*;}
-keep class com.huawei.updatesdk.**{*;}
-keep class com.huawei.hms.**{*;}
#环信
-keep class com.hyphenate.** {*;}
-dontwarn  com.hyphenate.**