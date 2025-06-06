class Heap:
    def __init__(self, array: list[int]):
        self.array = array
        self.size = len(array)
        self.make_heap()
        
    def make_heap(self) -> None:
        for i in range(self.size-1, -1, -1):
            self.heapify(i)
        return
        
    def get_children(self, node_i: int) -> tuple[int, int]:
        left_i = node_i * 2 + 1
        right_i = node_i * 2 + 2
        return left_i, right_i
    
    def get_parent(self, node_i) -> int:
        return (node_i - 1) // 2
        
    def heapify(self, node_i: int) -> None:
        left_i, right_i = self.get_children(node_i)
        
        largest_i = node_i
        
        if left_i < self.size and self.array[left_i] > self.array[largest_i]: 
            largest_i = left_i

        if right_i < self.size and self.array[right_i] > self.array[largest_i]: 
            largest_i = right_i
        
        if largest_i != node_i:
            self.array[node_i], self.array[largest_i] = self.array[largest_i], self.array[node_i]
            self.heapify(largest_i)
            
    def pop(self) -> int:
        if not self.size:
            return None

        self.array[0], self.array[-1] = self.array[-1], self.array[0]

        max_value = self.array.pop()
        
        self.size -= 1
        self.heapify(0)
        return max_value
    
    def increase_key(self, node_i) -> None:
        parent_i = self.get_parent(node_i)
        while parent_i >= 0 and self.array[parent_i] < self.array[node_i]:
            self.array[node_i], self.array[parent_i] = self.array[parent_i], self.array[node_i]
            node_i = parent_i
            parent_i = self.get_parent(node_i)
    
    def push(self, node) -> None:
        self.array.append(node)
        self.size += 1
        self.increase_key(self.size-1)
        return