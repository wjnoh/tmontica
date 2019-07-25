export type TMenusItem = {
  id: number;
  nameKo: string;
  nameEng: string;
  imgUrl: string;
};

export interface TBasicMenuOption {
  id: number;
  quantity: number;
}

export interface TMenuOption extends TBasicMenuOption {
  type: string;
  name: string;
  price: number | 0;
}

export type TMenu = {
  id: number;
  nameEng: string;
  nameKo: string;
  description: string;
  imgUrl: string;
  sellPrice: number;
  discountRate: number;
  category: string;
  stock: number;
  monthlyMenu: boolean;
  option: Array<TMenuOption>;
  getOptionById(id: number): TMenuOption;
};

export type TBasicMenuOptionArray = Array<TBasicMenuOption>;
export type TMenuOptionMap = Map<string, TMenuOption>;