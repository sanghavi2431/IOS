//
//  CollectionViewWrapper.swift
//  Woloo
//
//  Created by Rahul Patra on 02/08/21.
//

import Foundation
import UIKit

class GenericCollectionViewHelper: NSObject {
    
   typealias GenericNumberOfRows = ((UICollectionView, Int) -> Int)?
   typealias GenericCellForItemAt = ((UICollectionView, IndexPath) -> UICollectionViewCell)?
   typealias GenericSizeForItemAt = ((UICollectionView, UICollectionViewLayout, IndexPath) -> CGSize)?
   typealias GenericDidSelectItemAt = ((UICollectionView, IndexPath) -> Void)?
       
   fileprivate var numberOfRowsInSection: GenericNumberOfRows = nil
   fileprivate var cellForItemAt: GenericCellForItemAt = nil
   fileprivate var sizeForItemAt: GenericSizeForItemAt = nil
   fileprivate var didSelectItemAt: GenericDidSelectItemAt = nil
   
   func getNumberofRowsInSection(_ delegation: GenericNumberOfRows) {
       self.numberOfRowsInSection = delegation
   }
   
   func getCellForItemAt(_ delegation: GenericCellForItemAt) {
       self.cellForItemAt = delegation
   }
   
   func getSizeForItemAt(_ delegation: GenericSizeForItemAt) {
       self.sizeForItemAt = delegation
   }
   
   func getDidSelectItemAt(_ delegation: GenericDidSelectItemAt) {
       self.didSelectItemAt = delegation
   }
}

extension GenericCollectionViewHelper: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       numberOfRowsInSection?(collectionView, section) ?? 0
   }
   
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       cellForItemAt?(collectionView, indexPath) ?? UICollectionViewCell()
   }
   
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       sizeForItemAt?(collectionView, collectionViewLayout, indexPath) ?? .zero
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       didSelectItemAt?(collectionView, indexPath)
   }
}
