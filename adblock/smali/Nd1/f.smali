.class public final LNd1/f;
.super Ljava/lang/Object;
.source "BL"

# interfaces
.implements Lokhttp3/Interceptor$Chain;


# instance fields
.field public final a:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lokhttp3/Interceptor;",
            ">;"
        }
    .end annotation
.end field

.field public final b:LMd1/g;

.field public final c:LNd1/c;

.field public final d:LMd1/d;

.field public final e:I

.field public final f:Lokhttp3/Request;

.field public final g:Lokhttp3/h;

.field public final h:Lokhttp3/EventListener;

.field public final i:I

.field public final j:I

.field public final k:I

.field public l:I


# direct methods
.method public constructor <init>(Ljava/util/List;LMd1/g;LNd1/c;LMd1/d;ILokhttp3/Request;Lokhttp3/h;Lokhttp3/EventListener;III)V
    .locals 0

    .line 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 2
    .line 3
    .line 4
    iput-object p1, p0, LNd1/f;->a:Ljava/util/List;

    .line 5
    .line 6
    iput-object p4, p0, LNd1/f;->d:LMd1/d;

    .line 7
    .line 8
    iput-object p2, p0, LNd1/f;->b:LMd1/g;

    .line 9
    .line 10
    iput-object p3, p0, LNd1/f;->c:LNd1/c;

    .line 11
    .line 12
    iput p5, p0, LNd1/f;->e:I

    .line 13
    .line 14
    iput-object p6, p0, LNd1/f;->f:Lokhttp3/Request;

    .line 15
    .line 16
    iput-object p7, p0, LNd1/f;->g:Lokhttp3/h;

    .line 17
    .line 18
    iput-object p8, p0, LNd1/f;->h:Lokhttp3/EventListener;

    .line 19
    .line 20
    iput p9, p0, LNd1/f;->i:I

    .line 21
    .line 22
    iput p10, p0, LNd1/f;->j:I

    .line 23
    .line 24
    iput p11, p0, LNd1/f;->k:I

    .line 25
    .line 26
    return-void
.end method


# virtual methods
.method public final a(Lokhttp3/Request;LMd1/g;LNd1/c;LMd1/d;)Lokhttp3/Response;
    .locals 20
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 1
    move-object/from16 v0, p0

    .line 2
    .line 3
    iget-object v1, v0, LNd1/f;->a:Ljava/util/List;

    .line 4
    .line 5
    check-cast v1, Ljava/util/ArrayList;

    .line 6
    .line 7
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    .line 8
    .line 9
    .line 10
    move-result v1

    .line 11
    iget v2, v0, LNd1/f;->e:I

    .line 12
    .line 13
    if-ge v2, v1, :cond_8

    .line 14
    .line 15
    iget v1, v0, LNd1/f;->l:I

    .line 16
    .line 17
    const/4 v3, 0x1

    .line 18
    add-int/2addr v1, v3

    .line 19
    iput v1, v0, LNd1/f;->l:I

    .line 20
    .line 21
    iget-object v1, v0, LNd1/f;->c:LNd1/c;

    .line 22
    .line 23
    const-string v4, "network interceptor "

    .line 24
    .line 25
    if-eqz v1, :cond_1

    .line 26
    .line 27
    iget-object v5, v0, LNd1/f;->d:LMd1/d;

    .line 28
    .line 29
    invoke-virtual/range {p1 .. p1}, Lokhttp3/Request;->url()Lokhttp3/HttpUrl;

    .line 30
    .line 31
    .line 32
    move-result-object v6

    .line 33
    invoke-virtual {v5, v6}, LMd1/d;->k(Lokhttp3/HttpUrl;)Z

    .line 34
    .line 35
    .line 36
    move-result v5

    .line 37
    if-eqz v5, :cond_0

    .line 38
    .line 39
    goto :goto_0

    .line 40
    :cond_0
    new-instance v1, Ljava/lang/IllegalStateException;

    .line 41
    .line 42
    new-instance v5, Ljava/lang/StringBuilder;

    .line 43
    .line 44
    invoke-direct {v5, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 45
    .line 46
    .line 47
    iget-object v4, v0, LNd1/f;->a:Ljava/util/List;

    .line 48
    .line 49
    sub-int/2addr v2, v3

    .line 50
    check-cast v4, Ljava/util/ArrayList;

    .line 51
    .line 52
    invoke-virtual {v4, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    .line 53
    .line 54
    .line 55
    move-result-object v2

    .line 56
    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 57
    .line 58
    .line 59
    const-string v2, " must retain the same host and port"

    .line 60
    .line 61
    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 62
    .line 63
    .line 64
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 65
    .line 66
    .line 67
    move-result-object v2

    .line 68
    invoke-direct {v1, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    .line 69
    .line 70
    .line 71
    throw v1

    .line 72
    :cond_1
    :goto_0
    const-string v5, " must call proceed() exactly once"

    .line 73
    .line 74
    if-eqz v1, :cond_3

    .line 75
    .line 76
    iget v1, v0, LNd1/f;->l:I

    .line 77
    .line 78
    if-gt v1, v3, :cond_2

    .line 79
    .line 80
    goto :goto_1

    .line 81
    :cond_2
    new-instance v1, Ljava/lang/IllegalStateException;

    .line 82
    .line 83
    new-instance v6, Ljava/lang/StringBuilder;

    .line 84
    .line 85
    invoke-direct {v6, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 86
    .line 87
    .line 88
    iget-object v4, v0, LNd1/f;->a:Ljava/util/List;

    .line 89
    .line 90
    sub-int/2addr v2, v3

    .line 91
    check-cast v4, Ljava/util/ArrayList;

    .line 92
    .line 93
    invoke-virtual {v4, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    .line 94
    .line 95
    .line 96
    move-result-object v2

    .line 97
    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 98
    .line 99
    .line 100
    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 101
    .line 102
    .line 103
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 104
    .line 105
    .line 106
    move-result-object v2

    .line 107
    invoke-direct {v1, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    .line 108
    .line 109
    .line 110
    throw v1

    .line 111
    :cond_3
    :goto_1
    new-instance v1, LNd1/f;

    .line 112
    .line 113
    iget-object v15, v0, LNd1/f;->a:Ljava/util/List;

    .line 114
    .line 115
    add-int/lit8 v14, v2, 0x1

    .line 116
    .line 117
    iget-object v13, v0, LNd1/f;->g:Lokhttp3/h;

    .line 118
    .line 119
    iget-object v12, v0, LNd1/f;->h:Lokhttp3/EventListener;

    .line 120
    .line 121
    iget v11, v0, LNd1/f;->i:I

    .line 122
    .line 123
    iget v10, v0, LNd1/f;->j:I

    .line 124
    .line 125
    iget v9, v0, LNd1/f;->k:I

    .line 126
    .line 127
    move-object v6, v1

    .line 128
    move-object v7, v15

    .line 129
    move-object/from16 v8, p2

    .line 130
    .line 131
    move/from16 v17, v9

    .line 132
    .line 133
    move-object/from16 v9, p3

    .line 134
    .line 135
    move/from16 v16, v10

    .line 136
    .line 137
    move-object/from16 v10, p4

    .line 138
    .line 139
    move/from16 v18, v11

    .line 140
    .line 141
    move v11, v14

    .line 142
    move-object/from16 v19, v12

    .line 143
    .line 144
    move-object/from16 v12, p1

    .line 145
    .line 146
    move v3, v14

    .line 147
    move-object/from16 v14, v19

    .line 148
    .line 149
    move-object/from16 v19, v15

    .line 150
    .line 151
    move/from16 v15, v18

    .line 152
    .line 153
    invoke-direct/range {v6 .. v17}, LNd1/f;-><init>(Ljava/util/List;LMd1/g;LNd1/c;LMd1/d;ILokhttp3/Request;Lokhttp3/h;Lokhttp3/EventListener;III)V

    .line 154
    .line 155
    .line 156
    move-object/from16 v15, v19

    .line 157
    .line 158
    check-cast v15, Ljava/util/ArrayList;

    .line 159
    .line 160
    invoke-virtual {v15, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    .line 161
    .line 162
    .line 163
    move-result-object v2

    .line 164
    check-cast v2, Lokhttp3/Interceptor;

    .line 165
    .line 166
    invoke-interface {v2, v1}, Lokhttp3/Interceptor;->intercept(Lokhttp3/Interceptor$Chain;)Lokhttp3/Response;

    .line 167
    .line 168
    .line 169
    move-result-object v6

    .line 170
    if-eqz p3, :cond_5

    .line 171
    .line 172
    iget-object v7, v0, LNd1/f;->a:Ljava/util/List;

    .line 173
    .line 174
    check-cast v7, Ljava/util/ArrayList;

    .line 175
    .line 176
    invoke-virtual {v7}, Ljava/util/ArrayList;->size()I

    .line 177
    .line 178
    .line 179
    move-result v7

    .line 180
    if-ge v3, v7, :cond_5

    .line 181
    .line 182
    iget v1, v1, LNd1/f;->l:I

    .line 183
    .line 184
    const/4 v3, 0x1

    .line 185
    if-ne v1, v3, :cond_4

    .line 186
    .line 187
    goto :goto_2

    .line 188
    :cond_4
    new-instance v1, Ljava/lang/IllegalStateException;

    .line 189
    .line 190
    new-instance v3, Ljava/lang/StringBuilder;

    .line 191
    .line 192
    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 193
    .line 194
    .line 195
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 196
    .line 197
    .line 198
    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 199
    .line 200
    .line 201
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 202
    .line 203
    .line 204
    move-result-object v2

    .line 205
    invoke-direct {v1, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    .line 206
    .line 207
    .line 208
    throw v1

    .line 209
    :cond_5
    :goto_2
    const-string v1, "interceptor "

    .line 210
    .line 211
    if-eqz v6, :cond_7

    .line 212
    .line 213
    invoke-virtual {v6}, Lokhttp3/Response;->body()Lokhttp3/ResponseBody;

    .line 214
    .line 215
    .line 216
    move-result-object v3

    .line 217
    if-eqz v3, :cond_6

    .line 218
    .line 219
    return-object v6

    .line 220
    :cond_6
    new-instance v3, Ljava/lang/IllegalStateException;

    .line 221
    .line 222
    new-instance v4, Ljava/lang/StringBuilder;

    .line 223
    .line 224
    invoke-direct {v4, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 225
    .line 226
    .line 227
    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 228
    .line 229
    .line 230
    const-string v1, " returned a response with no body"

    .line 231
    .line 232
    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 233
    .line 234
    .line 235
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 236
    .line 237
    .line 238
    move-result-object v1

    .line 239
    invoke-direct {v3, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    .line 240
    .line 241
    .line 242
    throw v3

    .line 243
    :cond_7
    new-instance v3, Ljava/lang/NullPointerException;

    .line 244
    .line 245
    new-instance v4, Ljava/lang/StringBuilder;

    .line 246
    .line 247
    invoke-direct {v4, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 248
    .line 249
    .line 250
    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    .line 251
    .line 252
    .line 253
    const-string v1, " returned null"

    .line 254
    .line 255
    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 256
    .line 257
    .line 258
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 259
    .line 260
    .line 261
    move-result-object v1

    .line 262
    invoke-direct {v3, v1}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    .line 263
    .line 264
    .line 265
    throw v3

    .line 266
    :cond_8
    new-instance v1, Ljava/lang/AssertionError;

    .line 267
    .line 268
    invoke-direct {v1}, Ljava/lang/AssertionError;-><init>()V

    .line 269
    .line 270
    .line 271
    throw v1
.end method

.method public final call()Lokhttp3/Call;
    .locals 1

    .line 1
    iget-object v0, p0, LNd1/f;->g:Lokhttp3/h;

    .line 2
    .line 3
    return-object v0
.end method

.method public final connectTimeoutMillis()I
    .locals 1

    .line 1
    iget v0, p0, LNd1/f;->i:I

    .line 2
    .line 3
    return v0
.end method

.method public final connection()Lokhttp3/Connection;
    .locals 1

    .line 1
    iget-object v0, p0, LNd1/f;->d:LMd1/d;

    .line 2
    .line 3
    return-object v0
.end method

.method public final proceed(Lokhttp3/Request;)Lokhttp3/Response;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    invoke-static {p1}, Lcom/bilibili/adblock/AdBlockGuard;->guard2(Lokhttp3/Request;)V

    .line 1
    iget-object v0, p0, LNd1/f;->c:LNd1/c;

    .line 2
    .line 3
    iget-object v1, p0, LNd1/f;->d:LMd1/d;

    .line 4
    .line 5
    iget-object v2, p0, LNd1/f;->b:LMd1/g;

    .line 6
    .line 7
    invoke-virtual {p0, p1, v2, v0, v1}, LNd1/f;->a(Lokhttp3/Request;LMd1/g;LNd1/c;LMd1/d;)Lokhttp3/Response;

    .line 8
    .line 9
    .line 10
    move-result-object p1

    .line 11
    return-object p1
.end method

.method public final readTimeoutMillis()I
    .locals 1

    .line 1
    iget v0, p0, LNd1/f;->j:I

    .line 2
    .line 3
    return v0
.end method

.method public final request()Lokhttp3/Request;
    .locals 1

    .line 1
    iget-object v0, p0, LNd1/f;->f:Lokhttp3/Request;

    .line 2
    .line 3
    return-object v0
.end method

.method public final withConnectTimeout(ILjava/util/concurrent/TimeUnit;)Lokhttp3/Interceptor$Chain;
    .locals 16

    .line 1
    move-object/from16 v0, p0

    .line 2
    .line 3
    const-string v1, "timeout"

    .line 4
    .line 5
    move/from16 v2, p1

    .line 6
    .line 7
    int-to-long v2, v2

    .line 8
    move-object/from16 v4, p2

    .line 9
    .line 10
    invoke-static {v1, v2, v3, v4}, Lokhttp3/internal/Util;->checkDuration(Ljava/lang/String;JLjava/util/concurrent/TimeUnit;)I

    .line 11
    .line 12
    .line 13
    move-result v13

    .line 14
    new-instance v1, LNd1/f;

    .line 15
    .line 16
    iget-object v5, v0, LNd1/f;->a:Ljava/util/List;

    .line 17
    .line 18
    iget-object v11, v0, LNd1/f;->g:Lokhttp3/h;

    .line 19
    .line 20
    iget-object v12, v0, LNd1/f;->h:Lokhttp3/EventListener;

    .line 21
    .line 22
    iget-object v6, v0, LNd1/f;->b:LMd1/g;

    .line 23
    .line 24
    iget-object v7, v0, LNd1/f;->c:LNd1/c;

    .line 25
    .line 26
    iget-object v8, v0, LNd1/f;->d:LMd1/d;

    .line 27
    .line 28
    iget v9, v0, LNd1/f;->e:I

    .line 29
    .line 30
    iget-object v10, v0, LNd1/f;->f:Lokhttp3/Request;

    .line 31
    .line 32
    iget v14, v0, LNd1/f;->j:I

    .line 33
    .line 34
    iget v15, v0, LNd1/f;->k:I

    .line 35
    .line 36
    move-object v4, v1

    .line 37
    invoke-direct/range {v4 .. v15}, LNd1/f;-><init>(Ljava/util/List;LMd1/g;LNd1/c;LMd1/d;ILokhttp3/Request;Lokhttp3/h;Lokhttp3/EventListener;III)V

    .line 38
    .line 39
    .line 40
    return-object v1
.end method

.method public final withReadTimeout(ILjava/util/concurrent/TimeUnit;)Lokhttp3/Interceptor$Chain;
    .locals 16

    .line 1
    move-object/from16 v0, p0

    .line 2
    .line 3
    const-string v1, "timeout"

    .line 4
    .line 5
    move/from16 v2, p1

    .line 6
    .line 7
    int-to-long v2, v2

    .line 8
    move-object/from16 v4, p2

    .line 9
    .line 10
    invoke-static {v1, v2, v3, v4}, Lokhttp3/internal/Util;->checkDuration(Ljava/lang/String;JLjava/util/concurrent/TimeUnit;)I

    .line 11
    .line 12
    .line 13
    move-result v14

    .line 14
    new-instance v1, LNd1/f;

    .line 15
    .line 16
    iget-object v5, v0, LNd1/f;->a:Ljava/util/List;

    .line 17
    .line 18
    iget-object v11, v0, LNd1/f;->g:Lokhttp3/h;

    .line 19
    .line 20
    iget-object v12, v0, LNd1/f;->h:Lokhttp3/EventListener;

    .line 21
    .line 22
    iget-object v6, v0, LNd1/f;->b:LMd1/g;

    .line 23
    .line 24
    iget-object v7, v0, LNd1/f;->c:LNd1/c;

    .line 25
    .line 26
    iget-object v8, v0, LNd1/f;->d:LMd1/d;

    .line 27
    .line 28
    iget v9, v0, LNd1/f;->e:I

    .line 29
    .line 30
    iget-object v10, v0, LNd1/f;->f:Lokhttp3/Request;

    .line 31
    .line 32
    iget v13, v0, LNd1/f;->i:I

    .line 33
    .line 34
    iget v15, v0, LNd1/f;->k:I

    .line 35
    .line 36
    move-object v4, v1

    .line 37
    invoke-direct/range {v4 .. v15}, LNd1/f;-><init>(Ljava/util/List;LMd1/g;LNd1/c;LMd1/d;ILokhttp3/Request;Lokhttp3/h;Lokhttp3/EventListener;III)V

    .line 38
    .line 39
    .line 40
    return-object v1
.end method

.method public final withWriteTimeout(ILjava/util/concurrent/TimeUnit;)Lokhttp3/Interceptor$Chain;
    .locals 16

    .line 1
    move-object/from16 v0, p0

    .line 2
    .line 3
    const-string v1, "timeout"

    .line 4
    .line 5
    move/from16 v2, p1

    .line 6
    .line 7
    int-to-long v2, v2

    .line 8
    move-object/from16 v4, p2

    .line 9
    .line 10
    invoke-static {v1, v2, v3, v4}, Lokhttp3/internal/Util;->checkDuration(Ljava/lang/String;JLjava/util/concurrent/TimeUnit;)I

    .line 11
    .line 12
    .line 13
    move-result v15

    .line 14
    new-instance v1, LNd1/f;

    .line 15
    .line 16
    iget-object v5, v0, LNd1/f;->a:Ljava/util/List;

    .line 17
    .line 18
    iget-object v11, v0, LNd1/f;->g:Lokhttp3/h;

    .line 19
    .line 20
    iget-object v12, v0, LNd1/f;->h:Lokhttp3/EventListener;

    .line 21
    .line 22
    iget-object v6, v0, LNd1/f;->b:LMd1/g;

    .line 23
    .line 24
    iget-object v7, v0, LNd1/f;->c:LNd1/c;

    .line 25
    .line 26
    iget-object v8, v0, LNd1/f;->d:LMd1/d;

    .line 27
    .line 28
    iget v9, v0, LNd1/f;->e:I

    .line 29
    .line 30
    iget-object v10, v0, LNd1/f;->f:Lokhttp3/Request;

    .line 31
    .line 32
    iget v13, v0, LNd1/f;->i:I

    .line 33
    .line 34
    iget v14, v0, LNd1/f;->j:I

    .line 35
    .line 36
    move-object v4, v1

    .line 37
    invoke-direct/range {v4 .. v15}, LNd1/f;-><init>(Ljava/util/List;LMd1/g;LNd1/c;LMd1/d;ILokhttp3/Request;Lokhttp3/h;Lokhttp3/EventListener;III)V

    .line 38
    .line 39
    .line 40
    return-object v1
.end method

.method public final writeTimeoutMillis()I
    .locals 1

    .line 1
    iget v0, p0, LNd1/f;->k:I

    .line 2
    .line 3
    return v0
.end method
