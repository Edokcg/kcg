--太阳神的意志
function c77238365.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77238365.target)
    e1:SetOperation(c77238365.activate)
    c:RegisterEffect(e1)

    --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_SZONE)
    e52:SetOperation(c77238365.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_SZONE)
    e53:SetTargetRange(0xa,0xa)
    e53:SetTarget(c77238365.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_SZONE)
    e54:SetTargetRange(0xa,0xa)
    e54:SetTarget(c77238365.distg2)
    c:RegisterEffect(e54)
end
function c77238365.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa210)
end
function c77238365.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c77238365.filter,tp,LOCATION_GRAVE,0,nil)
    if chk==0 then return (Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) and g:GetCount()<=1) or (Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and g:GetCount()>1 and g:GetCount()<3) or (Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) and g:GetCount()>=3) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c77238365.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77238365.filter,tp,LOCATION_GRAVE,0,nil)
    if g:GetCount()<5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_SZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end		
    elseif g:GetCount()>=5 and g:GetCount()<8 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end	
    elseif g:GetCount()>=8 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.Destroy(g,REASON_EFFECT)
    end
end

function c77238365.disop2(e,tp,eg,ep,ev,re,r,rp)
  if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
      local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
      if g and g:IsContains(e:GetHandler()) then
          if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
              Duel.Destroy(re:GetHandler(),REASON_EFFECT)
          end
      end
  end
end
function c77238365.distg2(e,c)
  return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
      and c:GetCardTarget():IsContains(e:GetHandler())
end