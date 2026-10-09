console.log('Module static keys: ' + Object.getOwnPropertyNames(Module).join(','));
console.log('typeof Module.findExportByName = ' + (typeof Module.findExportByName));
console.log('typeof Module.getGlobalExportByName = ' + (typeof Module.getGlobalExportByName));
console.log('typeof Module.getExportByName = ' + (typeof Module.getExportByName));
try {
    var libc = Process.getModuleByName('libc.so');
    console.log('typeof libc.findExportByName = ' + (typeof libc.findExportByName));
    console.log('libc exit = ' + libc.findExportByName('exit'));
    console.log('libc _exit = ' + libc.findExportByName('_exit'));
} catch (e) { console.log('libc probe fail: ' + e); }
