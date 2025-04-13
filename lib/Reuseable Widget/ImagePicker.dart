import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class CustomImagePickerScreen extends StatefulWidget {
  @override
  _CustomImagePickerScreenState createState() =>
      _CustomImagePickerScreenState();
}

class _CustomImagePickerScreenState extends State<CustomImagePickerScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  List<AssetEntity> _recentImages = [];
  List<AssetPathEntity> _albums = [];
  String _selectedAlbum = "Recents";

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  Future<void> _fetchAlbums() async {
    final PermissionState permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      final List<AssetPathEntity> fetchedAlbums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      setState(() {
        _albums = fetchedAlbums;
        _selectedAlbum = _albums.first.name;
      });

      await _fetchImagesFromAlbum(_albums.first);
    } else {
      PhotoManager.openSetting();
    }
  }

  Future<void> _fetchImagesFromAlbum(AssetPathEntity album) async {
    final List<AssetEntity> images = await album.getAssetListPaged(page: 0, size: 50);

    setState(() {
      _recentImages = images;
      print('Loaded ${images.length} images from album: ${album.name}');
    });
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
      });
      Navigator.pop(context);
    }
  }

  void _selectImage(AssetEntity image) async {
    final File? file = await image.file;
    if (file != null) {
      final int fileSize = await file.length(); // File size in bytes
      final double fileSizeMB = fileSize / (1024 * 1024); // Convert to MB

      if (fileSizeMB > 5) {
        // Show Snackbar if the image size exceeds 5MB
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
        return; // Prevent selecting the image
      }
    }

    if (file != null) {
      setState(() {
        _selectedImage = file;
      });
    }
  }

  void _openAlbumSelectionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: _albums.map((album) {
            return ListTile(
              title: Text(album.name),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedAlbum = album.name;
                });
                _fetchImagesFromAlbum(album);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 500,
          color: Colors.black,
          child: Column(
            children: [
              Container(
                height: 350,
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : const Center(
                  child: Icon(
                    Icons.photo,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _openAlbumSelectionDialog,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.black,
                  child: Row(
                    children: [
                      Text(
                        _selectedAlbum,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.black,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: _recentImages.length + 1, // +1 for camera icon
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return GestureDetector(
                          onTap: _pickImageFromCamera,
                          child: Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else {
                        final AssetEntity image = _recentImages[index - 1];
                        return GestureDetector(
                          onTap: () => _selectImage(image),
                          child: FutureBuilder<Uint8List?>(
                            future: image.thumbnailDataWithSize(
                                const ThumbnailSize(200, 200)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done &&
                                  snapshot.data != null) {
                                return Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              }
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image, color: Colors.white),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedImage != null) {
                      Navigator.pop(context, _selectedImage?.path);
                      print('Selected image path: ${_selectedImage!.path}');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select an image.')),
                      );
                    }
                  },
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Image Picker'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _showImagePicker,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: const Icon(
              Icons.add,
              size: 40,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
