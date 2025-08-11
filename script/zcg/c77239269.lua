--达姿的第二仪式 （ZCG）
function c77239269.initial_effect(c)
    --Activate
      local e1=Effect.CreateEffect(c)
      e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
      e1:SetType(EFFECT_TYPE_ACTIVATE)
      e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
      e1:SetCode(EVENT_FREE_CHAIN)
      e1:SetCost(c77239269.cost)
      e1:SetTarget(c77239269.target)
      e1:SetOperation(c77239269.activate)
      c:RegisterEffect(e1)
      local e2=Effect.CreateEffect(c)
      e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e2:SetCode(EVENT_ADJUST)
      e2:SetRange(0x1ff)
      e2:SetCondition(c77239269.wincon)
      e2:SetOperation(c77239269.winop)
      c:RegisterEffect(e2)
  end
  function c77239269.cost(e,tp,eg,ep,ev,re,r,rp,chk)
      if chk==0 then return Duel.CheckLPCost(tp,Duel.GetLP(tp)-1) end
      Duel.PayLPCost(tp,Duel.GetLP(tp)-1)
  end
  function c77239269.filter(c,e,tp)
      return c:IsCode(77239292) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
  end
  function c77239269.target(e,tp,eg,ep,ev,re,r,rp,chk)
      if chk==0 then return Duel.IsExistingMatchingCard(c77239269.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)>0 end
      Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
  end
  function c77239269.activate(e,tp,eg,ep,ev,re,r,rp)
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g=Duel.SelectMatchingCard(tp,c77239269.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
      local tc=g:GetFirst()
      if not tc then return end 
      if Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)<=0 then return end
      if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)~=0 and e:GetHandler():RegisterFlagEffect(77239269,0,0,1) then
          Duel.BreakEffect()
          e:GetHandler():CancelToGrave()
          Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
          Duel.ShuffleHand(e:GetHandler():GetControler())
      end
  end
  function c77239269.filter1(c)
  return c:IsCode(77239280)
  end
  function c77239269.filter2(c)
  return c:GetOriginalCode()==77239239 or c:GetOriginalCode()==77239253 
  end
  function c77239269.filter3(c)
  return c:GetOriginalCode()==77240472
  end
  function c77239269.filter4(c)
  return c:IsCode(77239292)
  end
  function c77239269.filter5(c)
  return c:IsCode(77239269)
  end
  function c77239269.wincon(e,tp,eg,ep,ev,re,r,rp)
     return  e:GetHandler():GetFlagEffect(77239269)>0  and Duel.IsExistingMatchingCard(c77239269.filter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c77239269.filter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c77239269.filter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c77239269.filter4,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c77239269.filter5,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,0,1,nil) 
  end
  function c77239269.winop(e,tp,eg,ep,ev,re,r,rp)
      Duel.Win(tp,0x506)
  end
  
  
  
  