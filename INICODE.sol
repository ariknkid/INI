// Pengenal-Lisensi SPDX: MIT

soliditas pragma ^0.7.0;

impor "../../utils/Context.sol";
impor "./IERC20.sol";
impor "../../math/SafeMath.sol";

/**
 * @dev Implementasi antarmuka {IERC20}.
 *
 * Implementasi ini tidak sesuai dengan cara pembuatan token. Ini berarti
 * bahwa mekanisme pasokan harus ditambahkan dalam kontrak turunan menggunakan {_mint}.
 * Untuk mekanisme umum lihat {ERC20PresetMinterPauser}.
 *
 * TIPS: Untuk artikel terperinci, lihat panduan kami
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[Bagaimana
 * untuk menerapkan mekanisme pasokan].
 *
 * Kami telah mengikuti pedoman umum OpenZeppelin: fungsi dikembalikan
 * mengembalikan `false` jika gagal. Perilaku ini masih bersifat konvensional
 * dan tidak bertentangan dengan ekspektasi aplikasi ERC20.
 *
 * Selain itu, peristiwa {Approval} dikeluarkan pada panggilan ke {transferFrom}.
 * Hal ini memungkinkan aplikasi untuk merekonstruksi penyisihan untuk semua akun saja
 * dengan mendengarkan acara tersebut. Implementasi EIP lainnya mungkin tidak mengeluarkan emisi
 * kejadian ini, karena tidak diwajibkan oleh spesifikasi.
 *
 * Terakhir, {decreaseAllowance} dan {increaseAllowance} non-standar
 * Fungsi telah ditambahkan untuk mengurangi masalah umum seputar pengaturan
 * tunjangan. Lihat {IERC20-approve}.
 */
kontrak ERC20 adalah Konteks, IERC20 {
    menggunakan SafeMath untuk uint256;

    pemetaan (alamat => uint256) private _balances;

    pemetaan (alamat => pemetaan (alamat => uint256)) private _allowances;

    uint256 pribadi _totalSupply;

    string nama_pribadi;
    string _simbol pribadi;
    uint8 pribadi _desimal;

    /**
     * @dev Menetapkan nilai untuk {name} dan {symbol}, menginisialisasi {desimal} dengan
     * nilai default 12.
     *
     * Untuk memilih nilai berbeda untuk {desimal}, gunakan {_setupDecimals}.
     *
     * Ketiga nilai ini tidak dapat diubah: hanya dapat ditetapkan satu kali saja
     * konstruksi.
     */
    konstruktor (nama memori string_, simbol memori string_) {
        _nama = nama_;
        _simbol = simbol_;
        _desimal = 12;
    }

    /**
     * @dev Mengembalikan nama token.
     */
    nama fungsi() tampilan publik pengembalian virtual (memori string) {
        kembalikan _nama;
    }

    /**
     * @dev Mengembalikan simbol token, biasanya versi yang lebih pendek
     * nama.
     */
    simbol fungsi() tampilan publik pengembalian virtual (memori string) {
        kembalikan _simbol;
    }

    /**
     * @dev Mengembalikan jumlah desimal yang digunakan untuk mendapatkan representasi penggunanya.
     * Misalnya, jika `desimal` sama dengan `12`, saldo token `12000000000000` harus
     * ditampilkan kepada pengguna sebagai `12000000000000` (`12000000000000 / 10 ** 12`).
     *
     * Token biasanya memilih nilai 12, meniru hubungan antara keduanya
     * Eter dan Wei. Ini adalah nilai yang digunakan oleh {ERC20}, kecuali jika {_setupDecimals} digunakan
     * ditelepon.
     *
     * CATATAN: Informasi ini hanya digunakan untuk tujuan _display_: informasi ini ada di
     * tidak mempengaruhi aritmatika kontrak apa pun, termasuk
     * {IERC20-balanceOf} dan {IERC20-transfer}.
     */
    fungsi desimal() tampilan publik pengembalian virtual (uint8) {
        kembalikan _desimal;
    }

    /**
     * @dev Lihat {IERC20-totalSupply}.
     */
    function totalSupply() tampilan publik pengembalian virtual override (uint256) {
        kembalikan _totalSupply;
    }

    /**
     * @dev Lihat {IERC20-balanceOf}.
     */
    function balanceOf(akun alamat) tampilan umum pengembalian virtual override (uint256) {
        kembalikan _saldo[akun];
    }

    /**
     * @dev Lihat {IERC20-transfer}.
     *
     * Persyaratan:
     *
     * - `penerima` tidak boleh berupa alamat nol.
     * - penelepon harus memiliki saldo minimal `jumlah`.
     */
    transfer fungsi (alamat penerima, jumlah uint256) pengembalian penggantian virtual publik (bool) {
        _transfer(_msgSender(), penerima, jumlah);
        kembali benar;
    }

    /**
     * @dev Lihat {IERC20-allowance}.
     */
    tunjangan fungsi (pemilik alamat, pembelanja alamat) tampilan umum pengembalian penggantian virtual (uint256) {
        return _allowances[pemilik][pembelanja];
    }

    /**
     * @dev Lihat {IERC20-approve}.
     *
     * Persyaratan:
     *
     * - `pembelanja` tidak boleh berupa alamat nol.
     */
    fungsi menyetujui (alamat pembelanja, jumlah uint256) pengembalian penggantian virtual publik (bool) {
        _approve(_msgSender(), pembelanja, jumlah);
        kembali benar;
    }

    /**
     * @dev Lihat {IERC20-transferFrom}.
     *
     * Memancarkan peristiwa {Persetujuan} yang menunjukkan tunjangan yang diperbarui. Ini bukan
     * diperlukan oleh EIP. Lihat catatan di awal {ERC20}.
     *
     * Persyaratan:
     *
     * - `pengirim` dan `penerima` tidak boleh berupa alamat nol.
     * - `pengirim` harus memiliki saldo minimal `jumlah`.
     * - penelepon harus memiliki minimal token ``pengirim``
     * `jumlah`.
     */
    transfer fungsiDari(alamat pengirim, alamat penerima, jumlah uint256) pengembalian penggantian virtual publik (bool) {
        _transfer(pengirim, penerima, jumlah);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: jumlah transfer melebihi tunjangan"));
        kembali benar;
    }

    /**
     * @dev Secara atom meningkatkan tunjangan yang diberikan kepada `pembelanja` oleh penelepon.
     *
     * Ini merupakan alternatif dari {approve} yang dapat digunakan sebagai mitigasi
     * masalah yang dijelaskan di {IERC20-approve}.
     *
     * Memancarkan peristiwa {Persetujuan} yang menunjukkan tunjangan yang diperbarui.
     *
     * Persyaratan:
     *
     * - `pembelanja` tidak boleh berupa alamat nol.
     */
    fungsi peningkatanAllowance(alamat pembelanja, uint256 nilai tambah) pengembalian virtual publik (bool) {
        _approve(_msgSender(), pembelanja, _allowances[_msgSender()][spender].add(addedValue));
        kembali benar;
    }

    /**
     * @dev Secara atom mengurangi tunjangan yang diberikan kepada `pembelanja` oleh penelepon.
     *
     * Ini merupakan alternatif dari {approve} yang dapat digunakan sebagai mitigasi
     * masalah yang dijelaskan di {IERC20-approve}.
     *
     * Memancarkan peristiwa {Persetujuan} yang menunjukkan tunjangan yang diperbarui.
     *
     * Persyaratan:
     *
     * - `pembelanja` tidak boleh berupa alamat nol.
     * - `pembelanja` setidaknya harus memiliki uang saku untuk penelepon
     * `Nilai yang dikurangi`.
     */
    fungsi penurunanAllowance(alamat pembelanja, uint256 subtratedValue) pengembalian virtual publik (bool) {
        _approve(_msgSender(), pembelanja, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: penurunan tunjangan di bawah nol"));
        kembali benar;
    }

    /**
     * @dev Memindahkan token `jumlah` dari `pengirim` ke `penerima`.
     *
     * Ini adalah fungsi internal yang setara dengan {transfer}, dan dapat digunakan
     *misalnya menerapkan biaya token otomatis, mekanisme pemotongan, dll.
     *
     * Memancarkan peristiwa {Transfer}.
     *
     * Persyaratan:
     *
     * - `pengirim` tidak boleh berupa alamat nol.
     * - `penerima` tidak boleh berupa alamat nol.
     * - `pengirim` harus memiliki saldo minimal `jumlah`.
     */
    fungsi _transfer(alamat pengirim, alamat penerima, jumlah uint256) virtual internal {
        require(sender != address(0), "ERC20: transfer dari alamat nol");
        require(penerima != alamat(0), "ERC20: transfer ke alamat nol");

        _beforeTokenTransfer(pengirim, penerima, jumlah);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: jumlah transfer melebihi saldo");
        _saldo[penerima] = _saldo[penerima].tambah(jumlah);
        memancarkan Transfer(pengirim, penerima, jumlah);
    }

    /** @dev Membuat token `jumlah` dan menugaskannya ke `akun`, meningkat
     * total pasokan.
     *
     * Memancarkan acara {Transfer} dengan `dari` disetel ke alamat nol.
     *
     * Persyaratan:
     *
     * - `to` tidak boleh berupa alamat nol.
     */
    fungsi _mint(alamat rekening, jumlah uint256) virtual internal {
        require(akun != alamat(0), "ERC20: mint ke alamat nol");

        _beforeTokenTransfer(alamat(0), rekening, jumlah);

        _totalSupply = _totalSupply.tambahkan(jumlah);
        _saldo[akun] = _saldo[akun].tambahan(jumlah);
        memancarkan Transfer(alamat(0), rekening, jumlah);
    }

    /**
     * @dev Hancurkan token `jumlah` dari `akun`, sehingga mengurangi
     * jumlah pasokan.
     *
     * Memancarkan acara {Transfer} dengan `to` disetel ke alamat nol.
     *
     * Persyaratan:
     *
     * - `akun` tidak boleh berupa alamat nol.
     * - `akun` harus memiliki setidaknya `jumlah` token.
     */
    fungsi _burn(alamat rekening, jumlah uint256) virtual internal {
        require(akun != alamat(0), "ERC20: bakar dari alamat nol");

        _beforeTokenTransfer(akun, alamat(0), jumlah);

        _balances[account] = _balances[account].sub(amount, "ERC20: jumlah pembakaran melebihi saldo");
        _totalSupply = _totalSupply.sub(jumlah);
        emit Transfer(rekening, alamat(0), jumlah);
    }

    /**
     * @dev Menetapkan `jumlah` sebagai jatah `pembelanja` atas token `pemilik`.
     *
     * Fungsi internal ini setara dengan `menyetujui`, dan dapat digunakan untuk itu
     *misalnya menetapkan tunjangan otomatis untuk subsistem tertentu, dll.
     *
     * Memancarkan peristiwa {Persetujuan}.
     *
     * Persyaratan:
     *
     * - `pemilik` tidak boleh berupa alamat nol.
     * - `pembelanja` tidak boleh berupa alamat nol.
     */
    fungsi _approve(pemilik alamat, alamat pembelanja, jumlah uint256) virtual internal {
        require(pemilik != alamat(0), "ERC20: setujui dari alamat nol");
        require(spender != address(0), "ERC20: setujui ke alamat nol");

        _tunjangan[pemilik][pembelanja] = jumlah;
        memancarkan Persetujuan (pemilik, pembelanja, jumlah);
    }

    /**
     * @dev Menyetel {desimal} ke nilai selain nilai default 12.
     *
     * PERINGATAN: Fungsi ini hanya boleh dipanggil dari konstruktor. Paling
     * Aplikasi yang berinteraksi dengan kontrak token tidak akan diharapkan
     * {desimal} selalu berubah, dan mungkin tidak berfungsi dengan benar jika berubah.
     */
    fungsi _setupDecimals(uint8 desimal_) virtual internal {
        _desimal = desimal_;
    }

    /**
     * @dev Hook yang dipanggil sebelum transfer token apa pun. Ini termasuk
     * mencetak dan membakar.
     *
     * Ketentuan panggilan:
     *
     * - ketika `dari` dan `ke` keduanya bukan nol, `jumlah` token ``dari``
     * akan ditransfer ke `ke`.
     * - ketika `dari` adalah nol, token `jumlah` akan dicetak untuk `ke`.
     * - ketika `to` adalah nol, `jumlah` token ``dari`` akan dibakar.
     * - `dari` dan `ke` keduanya tidak pernah nol.
     *
     * Untuk mempelajari lebih lanjut tentang hooks, kunjungi xref:ROOT:extending-contracts.adoc#using-hooks[Menggunakan Hooks].
     */
    fungsi _beforeTokenTransfer(alamat dari, alamat ke, jumlah uint256) virtual internal {}
}
