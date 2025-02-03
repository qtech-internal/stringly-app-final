import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class CustomImagePicker extends StatefulWidget {
  @override
  _CustomImagePickerState createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  List<AssetEntity> recentImages = [];
  List<AssetEntity> selectedImages = [];
  List<AssetPathEntity> albums = [];
  AssetPathEntity? selectedAlbum;

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  Future<void> _fetchAlbums() async {
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      final List<AssetPathEntity> albumList =
          await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      setState(() {
        albums = albumList;
        selectedAlbum = albums.isNotEmpty ? albums.first : null;
      });

      if (selectedAlbum != null) {
        _fetchImagesFromAlbum(selectedAlbum!);
      }
    } else {
      PhotoManager.openSetting();
    }
  }

  Future<void> _fetchImagesFromAlbum(AssetPathEntity album) async {
    final List<AssetEntity> images =
        await album.getAssetListPaged(page: 0, size: 50);
    setState(() {
      recentImages = images;
    });
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      Navigator.pop(context, [photo.path]);
    }
  }


  void _toggleImageSelection(AssetEntity image) async {
    final File? file = await image.file;
    if (file != null) {
      final int fileSize = await file.length(); // Get file size in bytes
      final double fileSizeMB = fileSize / (1024 * 1024); // Convert to MB

      if (fileSizeMB > 5) {
        // Show a snackbar if the image size exceeds 5MB
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'The selected image is too large (${fileSizeMB.toStringAsFixed(
                  2)} MB). Please choose an image smaller than 5MB.',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return; // Prevent selection of the image
      }
    }
    setState(() {
      if (selectedImages.contains(image)) {
        selectedImages.remove(image);
      } else {
        selectedImages.add(image);
      }
    });
  }

  void _showAlbumPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.black,
          child: ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return ListTile(
                title: Text(
                  album.name,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedAlbum = album;
                  });
                  _fetchImagesFromAlbum(album);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Large preview for the first image
          recentImages.isNotEmpty
              ? FutureBuilder<File?>(
                  future: recentImages.first.file,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data != null) {
                      return Image.file(
                        snapshot.data!,
                        height: 350,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    }
                    return const SizedBox(
                      height: 350,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                )
              : const SizedBox(
                  height: 350,
                  child: Center(
                      child: Text('No image selected',
                          style: TextStyle(color: Colors.white))),
                ),
          // Recents dropdown
          Container(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _showAlbumPicker,
              child: Row(
                children: [
                  Text(
                    selectedAlbum?.name ?? 'Recents',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
          // Images grid
          Expanded(
            child: Container(
              color: Colors.black,
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: recentImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: _pickImageFromCamera,
                      child: Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.camera_alt,
                            size: 40, color: Colors.white),
                      ),
                    );
                  }
                  final AssetEntity image = recentImages[index - 1];
                  final bool isSelected = selectedImages.contains(image);
                  return GestureDetector(
                    onTap: () => _toggleImageSelection(image),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        FutureBuilder<Uint8List?>(
                          future: image.thumbnailDataWithSize(
                              const ThumbnailSize(200, 200)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.data != null) {
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                        if (isSelected)
                          Container(
                            color: Colors.black.withOpacity(0.5),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Upload button
          Container(
            width: 350,
            padding: const EdgeInsets.only(top: 8.0, bottom: 25),
            child: ElevatedButton(
              onPressed: () async {
                List<File?> files = await Future.wait(
                  selectedImages.map((image) => image.file),
                );
                files.removeWhere((file) => file == null);
                Navigator.pop(
                    context, files.map((file) => file!.path).toList());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Set Profile'),
            ),
          ),
        ],
      ),
    );
  }
}
