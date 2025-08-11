--マアト
function c201.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcCode2(c,57116033,47297616,false,false)

	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c201.splimit)
	c:RegisterEffect(e1)

	--special summon
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_SPSUMMON_PROC)
	--e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	--e2:SetRange(LOCATION_HAND)
	--e2:SetCondition(c201.spcon)
	--e2:SetOperation(c201.spop)
	--c:RegisterEffect(e2)

	--announce 3 cards
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18631392,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1)
	e3:SetTarget(c201.anctg)
	c:RegisterEffect(e3)
end

function c201.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function c201.spfilter(c,rac)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(rac) and c:IsAbleToGraveAsCost()
end
function c201.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c201.spfilter,tp,LOCATION_MZONE,0,1,nil,RACE_FAIRY)
		and Duel.IsExistingMatchingCard(c201.spfilter,tp,LOCATION_MZONE,0,1,nil,RACE_DRAGON)
end
function c201.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c201.spfilter,tp,LOCATION_MZONE,0,1,1,nil,RACE_FAIRY)
	if #g1<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c201.spfilter,tp,LOCATION_MZONE,0,1,1,nil,RACE_DRAGON)
	if #g2<1 then return end
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end

function c201.anctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 and e:GetHandler():GetFlagEffect(201)==0 end
      if Duel.GetFlagEffect(tp,92999980)~=0 and Duel.GetFlagEffect(tp,201)<6 and Duel.GetLP(1-tp)-Duel.GetLP(tp)>=4000 then
      if Duel.SelectYesNo(tp,aux.Stringid(123106,11)) then
      local g=Duel.GetDecktopGroup(tp,1)
      Duel.ConfirmCards(tp,g)
      Duel.RegisterFlagEffect(tp,201,0,nil,0)
      Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(123106,11)) end end
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE) 
	  local ac1=Duel.AnnounceCard(tp,OPCODE_ALLOW_ALIASES)
      e:GetHandler():RegisterFlagEffect(201,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:SetOperation(c201.retop(ac1))
end
function c201.hfilter(c,code1)
	local code=c:GetOriginalCode()
	return code==code1 and c:IsAbleToHand()
end
function c201.retop(code1)
	return
		function (e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
                  local g=Duel.GetDecktopGroup(tp,1)
			local hg=g:Filter(c201.hfilter,nil,code1)
			if hg:GetCount()~=0 then
				Duel.SendtoHand(hg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,hg)
				Duel.ShuffleHand(tp)
                        e:GetHandler():ResetFlagEffect(201)
			end
			if hg:GetCount()==0 then
				Duel.SendtoGrave(g:GetFirst(),REASON_EFFECT+REASON_REVEAL)
			end
			if c:IsRelateToEffect(e) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(hg:GetCount()*1000)
				e1:SetReset(RESET_EVENT+0x1ff0000)
				c:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				c:RegisterEffect(e2)
			end
		end
end

function c201.anctg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE) 
	local ac1=Duel.AnnounceCard(tp,OPCODE_ALLOW_ALIASES)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE) 
	local ac2=Duel.AnnounceCard(tp,OPCODE_ALLOW_ALIASES)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE) 
	local ac3=Duel.AnnounceCard(tp,OPCODE_ALLOW_ALIASES)
	e:SetOperation(c201.retop(ac1,ac2,ac3))
end
function c201.hfilter2(c,code1,code2,code3)
	local code=c:GetCode()
	return (code==code1 or code==code2 or code==code3) and c:IsAbleToHand()
end
function c201.retop2(code1,code2,code3)
	return
		function (e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			Duel.ConfirmDecktop(tp,3)
			local g=Duel.GetDecktopGroup(tp,3)
			local hg=g:Filter(c201.hfilter,nil,code1,code2,code3)
			g:Sub(hg)
			if hg:GetCount()~=0 then
				Duel.DisableShuffleCheck()
				Duel.SendtoHand(hg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,hg)
				Duel.ShuffleHand(tp)
			end
			if g:GetCount()~=0 then
				Duel.DisableShuffleCheck()
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			end
			if c:IsRelateToEffect(e) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_SINGLE_RANGE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetCode(EFFECT_SET_ATTACK)
				e1:SetValue(hg:GetCount()*1000)
				e1:SetReset(RESET_EVENT+0x1ff0000)
				c:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_SET_DEFENSE)
				c:RegisterEffect(e2)
			end
		end
end
