--冥界守护者 埃阿斯(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	  --destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetReason(),0x41)==0x41 and rp~=e:GetHandler():GetControler()
end
function s.filter(c)
	return c:IsSetCard(0xa13) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,0,nil)
   if #g<=0 then return false end
   local tc=g:GetFirst()
   local num=0
   while tc do
   if tc:GetAttack()>0 then
   num=num+tc:GetAttack()
   end
   tc=g:GetNext()
  end
   Duel.Damage(1-tp,num,REASON_EFFECT)
  Duel.BreakEffect()
  Duel.Draw(tp,2,REASON_EFFECT)
end












