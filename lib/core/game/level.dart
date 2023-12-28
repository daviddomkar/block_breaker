import 'entities/block.dart';

// We use this to represent an empty cell in the level data.
// It being one letter makes it easier to read the level data.
const int E = -1;

class Level {
  final int width;
  final int height;
  final List<List<int>> data;

  Level({
    required this.width,
    required this.height,
    required this.data,
  })  : assert(width > 0 && width <= 6),
        assert(height > 0 && height <= 20),
        assert(data.length == height),
        assert(data.every((row) => row.length == width));
}

List<Level> levels = List.unmodifiable([
  // Level 1
  Level(
    width: 5,
    height: 4,
    data: [
      [4, 4, 4, 4, 4],
      [3, 3, 3, 3, 3],
      [2, 2, 2, 2, 2],
      [1, 1, 1, 1, 1],
    ],
  ),
  // Level 2
  Level(
    width: 5,
    height: 18,
    data: [
      [E, E, E, E, E],
      [E, E, E, E, E],
      [E, E, E, E, E],
      [3, E, E, E, 3],
      [E, 4, E, 4, E],
      [E, E, 1, E, E],
      [3, E, E, E, 3],
      [E, 4, E, 4, E],
      [E, E, 1, E, E],
      [3, E, E, E, 3],
      [E, 4, E, 4, E],
      [E, E, 1, E, E],
      [3, E, E, E, 3],
      [E, 4, E, 4, E],
      [E, E, 1, E, E],
      [3, E, E, E, 3],
      [E, 4, E, 4, E],
      [E, E, 1, E, E],
    ],
  ),
  // Level 3
  Level(
    width: 5,
    height: 18,
    data: [
      [E, E, E, E, E],
      [E, E, E, E, E],
      [E, E, E, E, E],
      [E, E, 1, E, E],
      [E, 1, 4, 1, E],
      [3, E, 1, E, E],
      [4, 3, E, E, E],
      [3, E, 1, E, E],
      [E, 1, 4, 1, E],
      [E, E, 1, E, 3],
      [E, E, E, 3, 4],
      [E, E, 1, E, 3],
      [E, 1, 4, 1, E],
      [3, E, 1, E, E],
      [4, 3, E, E, E],
      [3, E, 1, E, E],
      [E, 1, 4, 1, E],
      [E, E, 1, E, E],
    ],
  ),
  // Level 8
  Level(
    width: 5,
    height: BlockType.values.length * 4,
    data: [
      for (int i = 0; i < BlockType.values.length * 4; i++)
        [
          for (int j = 0; j < 5; j++)
            BlockType.values[i % BlockType.values.length].index,
        ],
    ],
  ),
  // Level 9
  Level(
    width: 5,
    height: 20,
    data: [
      [E, E, 0, E, E],
      [E, 0, 1, 0, E],
      [0, 1, 1, 1, 0],
      [1, 1, 2, 1, 1],
      [1, 2, 2, 2, 1],
      [0, 2, 3, 2, 0],
      [2, 3, 3, 3, 2],
      [2, 3, 4, 3, 2],
      [0, 4, 4, 4, 0],
      [3, 4, 4, 4, 3],
      [3, 4, 4, 4, 3],
      [0, 4, 4, 4, 0],
      [2, 3, 4, 3, 2],
      [2, 3, 3, 3, 2],
      [0, 2, 3, 2, 0],
      [1, 2, 2, 2, 1],
      [1, 1, 2, 1, 1],
      [0, 1, 1, 1, 0],
      [E, 0, 1, 0, E],
      [E, E, 0, E, E],
    ],
  ),
  // Level 10
  Level(
    width: 5,
    height: 20,
    data: [
      [0, E, E, E, E],
      [2, 0, E, E, E],
      [2, 2, 0, E, E],
      [0, 2, 2, 0, E],
      [3, 0, 2, 2, 0],
      [3, 3, 0, 2, 2],
      [0, 3, 3, 0, 2],
      [4, 0, 3, 3, 0],
      [4, 4, 0, 3, 3],
      [0, 4, 4, 0, 3],
      [3, 0, 4, 4, 0],
      [3, 3, 0, 4, 4],
      [0, 3, 3, 0, 4],
      [2, 0, 3, 3, 0],
      [2, 2, 0, 3, 3],
      [0, 2, 2, 0, 3],
      [E, 0, 2, 2, 0],
      [E, E, 0, 2, 2],
      [E, E, E, 0, 2],
      [E, E, E, E, 0],
    ],
  ),
]);
