<!-- -*- coding: utf-8 -*- -->
# テスト用証明書作成キット

このキットは以下のような証明書を作成できます；

- ルート証明書
- 中間証明書
- サーバ証明書
- クライアント証明書
- コードサイニング証明書
- タイムスタンプ証明書

等

## 必要なもの

- openssl 1.0.1f
- GNU Make
- bash etc.
- perl
- /dev/random

## ディレクトリとファイル

- 1つのディレクトリが1つの証明書に対応します。
- 証明書ディレクトリの ``cert.conf'' ファイルは、主設定ファイルです。
- 証明書ディレクトリの ``Makefile'' ファイルは、証明書のメイクファイルです。

## 使い方

トップディレクトリで ``make'' を実行すると、サンプル証明書ができます。
設定ファイルやメイクファイルを編集することによって、様々な証明書ができます。

## ライセンス

Copyright (C) 2014 Masamichi Hosoda. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.
