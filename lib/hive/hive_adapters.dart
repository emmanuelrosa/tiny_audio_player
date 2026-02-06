import 'package:hive_ce/hive_ce.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tiny_audio_player/playlist/playlist_storage_service.dart';

@GenerateAdapters([AdapterSpec<SerializedMedia>(), AdapterSpec<PlaylistMode>()])
part 'hive_adapters.g.dart';
