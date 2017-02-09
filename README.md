Composer
========

**Composer adalah autogenerator web application yang akan membentuk aplikasi berbasis web dengan bantuan CMS Zotonic.**

Pada dasarnya composer adalah zotonic yang dimodifikasi dengan tambahan berupa script untuk dapat membaca masukan berupa owl sehingga aplikasi web yang dihasilkan memiliki kerangka yang sesuai dengan desain pada dokumen owl tersebut.

Installation
------------

Unduh dan install zotonic sesuai dengan langkah yang terdapat pada website zotonic. Kemudian tambahkan dan overwrite beberapa file terhadap folder zotonic yang telah diunduh. Peletakkan file bersesuaian dengan posisi file pada repository ini.

Dokumen owl yang digunakan adalah charity_org_rdf.owl. Apabila nama owl yang ingin digunakan berbeda, maka perlu juga adanya pengubahan nama owl pada script classAndObjectPropertyMapper.sh dan datatypePropertyMapper.sh.

Untuk menjalankan script, pertama jalankan perintah make pada terminal (yang akan menjalankan script classAndObjectPropertyMapper.sh) lalu kemudian jalankan perintah addsite yang sesuai dengan langkah pembentukan site oleh zotonic (yang akan menjalankan script datatypePropertyMapper.sh). Setelah kedua perintah tersebut dijalankan, maka situs yang terbentuk akan memiliki kerangka yang sesuai dengan owl masukan.
