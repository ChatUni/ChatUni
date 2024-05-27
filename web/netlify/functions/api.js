import { last } from 'lodash';

export default async (req, context) => {
  return new Response(last([2,3,4,5]));
};