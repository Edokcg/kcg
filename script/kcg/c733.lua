--HERO
function c733.initial_effect(c)
	--c:SetUniqueOnField(1,1,198)
	Fusion.AddProcMixRep(c,true,true,c733.ffilter,3,3,c733.ffilter1,c733.ffilter2)
	c:EnableReviveLimit()

	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c733.spcon)
	--c:RegisterEffect(e2)

	  local e00=Effect.CreateEffect(c)
	  e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	  e00:SetCode(EFFECT_SET_ATTACK)
	  e00:SetValue(c733.atkvalue)
	  c:RegisterEffect(e00)
	  e01=e00:Clone()
	  e01:SetCode(EFFECT_SET_DEFENSE)
	  e01:SetValue(c733.defvalue)
	  c:RegisterEffect(e01)
	  local e02=e00:Clone()
	  e02:SetCode(EFFECT_UPDATE_ATTACK)
	  e02:SetValue(c733.atkvalue2)
	  c:RegisterEffect(e02)

	  local e3=Effect.CreateEffect(c)
	  e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	  e3:SetCode(EFFECT_EXTRA_ATTACK)
	-- e3:SetCondition(c733.bp2con)
	  e3:SetValue(1)
	  c:RegisterEffect(e3)
	--   local e32=e3:Clone()
	--   e32:SetCode(EFFECT_ATTACK_ALL)
	-- e32:SetCondition(c733.bp2con2)
	  --c:RegisterEffect(e32)

	--damage conversion
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_REVERSE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c733.bp2con)
	e4:SetTargetRange(1,0)
	e4:SetValue(c733.rev)
	--c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE) 
	e5:SetCode(EFFECT_DEFENSE_ATTACK)
	e5:SetValue(1)
	--c:RegisterEffect(e5)

	--equip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(83965310,1))
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c733.eqtg)
	e6:SetOperation(c733.eqop)
	--c:RegisterEffect(e6)

	  local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	  e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	  e8:SetCode(EVENT_SUMMON_SUCCESS)
	  e8:SetTargetRange(LOCATION_MZONE,0)
	  e8:SetOperation(c733.spoperation)
	  Duel.RegisterEffect(e8,0)
	  local e9=e8:Clone()
	  e9:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	  Duel.RegisterEffect(e9,0)
	  local e10=e8:Clone()
	  e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	  Duel.RegisterEffect(e10,0)

	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_CANNOT_DISABLE)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	  local e112=e11:Clone()
	e112:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e112)
	  local e113=e11:Clone()
	e113:SetCode(EFFECT_IMMUNE_EFFECT)
	e113:SetValue(c733.efilter)
	--c:RegisterEffect(e113)
	--特殊召唤不会被无效化
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e12)

	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(83965310,0))
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e13:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e13:SetType(EFFECT_TYPE_IGNITION)
	e13:SetCountLimit(1)
	e13:SetRange(LOCATION_MZONE)
	e13:SetTarget(c733.drawtar)
	e13:SetOperation(c733.drawop)
	c:RegisterEffect(e13)

	--grave redirect
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e14:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e14:SetRange(LOCATION_MZONE)
	e14:SetValue(LOCATION_REMOVED)
	e14:SetCondition(c733.bp2con2)
	e14:SetTarget(c733.rmtg)
	--c:RegisterEffect(e14)

	--battle damage
	local e15=Effect.CreateEffect(c)
	e15:SetDescription(aux.Stringid(25366484,0))
	e15:SetCategory(CATEGORY_DAMAGE)
	e15:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e15:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e15:SetCode(EVENT_BATTLE_DESTROYING)
	e15:SetCondition(c733.damgcon)
	e15:SetTarget(c733.damgtg)
	e15:SetOperation(c733.damgop)
	c:RegisterEffect(e15)

	local e16=Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(13732,3))
	e16:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e16:SetType(EFFECT_TYPE_IGNITION)
	e16:SetCountLimit(1)
	e16:SetRange(LOCATION_MZONE)
	  e16:SetCost(c733.skipcost)
	e16:SetOperation(c733.skipop)
	--c:RegisterEffect(e16)
	  local e17=e16:Clone()
	e17:SetDescription(aux.Stringid(13732,8))
	  e17:SetCost(c733.skipcost2)
	e17:SetOperation(c733.skipop2)
	--c:RegisterEffect(e17)

	  local e18=Effect.CreateEffect(c)
	  e18:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	  e18:SetCode(EVENT_LEAVE_FIELD)
	  e18:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e18:SetOperation(c733.returnop)
	  c:RegisterEffect(e18)
end
c733.a=0 c733.a2=0 c733.a3=0 c733.a4=0 c733.a5=0 c733.a6=0 c733.a7=0

function c733.ffilter(c,fc,sumtype,tp)
	return c:IsSetCard(0x5008,fc,sumtype,tp) or c:IsSetCard(0x6008,fc,sumtype,tp) or c:IsSetCard(0xa008,fc,sumtype,tp) or c:IsSetCard(0xc008,fc,sumtype,tp) or c:IsSummonCode(fc, sumtype, tp, 23204029) or c:IsSummonCode(fc, sumtype, tp, 501000018) or c:IsSetCard(0x908,fc,sumtype,tp) or c:IsSetCard(0x3008,fc,sumtype,tp)
end
function c733.ffilter1(c,fc,sumtype,tp)
	return c:IsSetCard(0x3008,fc,sumtype,tp)
end
function c733.ffilter2(c,fc,sumtype,tp)
	return c:IsSetCard(0x5008,fc,sumtype,tp) or c:IsSetCard(0x6008,fc,sumtype,tp) or c:IsSetCard(0xa008,fc,sumtype,tp) or c:IsSetCard(0xc008,fc,sumtype,tp) or c:IsSummonCode(fc, sumtype, tp, 23204029) or c:IsSummonCode(fc, sumtype, tp, 501000018) or c:IsSetCard(0x908,fc,sumtype,tp)
end

function c733.atkvalue(e)
	  local c=e:GetHandler()  
	  local g=Duel.GetMatchingGroup(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,0x3008)
	  local g1=Duel.GetMatchingGroup(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,0x5008)
	  local g2=Duel.GetMatchingGroup(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,0x6008)
	  local g3=Duel.GetMatchingGroup(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,0xa008)
	  local g4=Duel.GetMatchingGroup(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,0xc008)
	  local g5=Duel.GetMatchingGroup(Card.IsCode,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,23204029)
	  local g6=Duel.GetMatchingGroup(Card.IsCode,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,501000018)
	  local g7=Duel.GetMatchingGroup(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,0x908)
	  local g8=Duel.GetMatchingGroup(Card.IsCode,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,198)
	  local g9=Duel.GetMatchingGroup(Card.IsCode,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,159)
	  g:Merge(g1)
	  g:Merge(g2)
	  g:Merge(g3) 
	  g:Merge(g4)
	  g:Merge(g5)
	  g:Merge(g6)
	  g:Merge(g7)
	  g:Merge(g8)
	  g:Merge(g9)
	  local atk=g:GetCount()*500
	  local atk2=(c733.a+c733.a2+c733.a3+c733.a4+c733.a5+c733.a6+c733.a7)*500
	  if atk>atk2 then return atk  
	  else return atk2 end   
end
function c733.defvalue(e)
	  local g=Duel.GetMatchingGroup(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,0x3008)
	  local g1=Duel.GetMatchingGroup(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,0x5008)
	  local g2=Duel.GetMatchingGroup(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,0x6008)
	  local g3=Duel.GetMatchingGroup(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,0xa008)
	  local g4=Duel.GetMatchingGroup(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,0xc008)
	  local g5=Duel.GetMatchingGroup(Card.IsCode,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,23204029)
	  local g6=Duel.GetMatchingGroup(Card.IsCode,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,501000018)
	  local g7=Duel.GetMatchingGroup(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,0x908)
	  local g8=Duel.GetMatchingGroup(Card.IsCode,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,198)
	  local g9=Duel.GetMatchingGroup(Card.IsCode,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,159)
	  g:Merge(g1)
	  g:Merge(g2)
	  g:Merge(g3) 
	  g:Merge(g4)
	  g:Merge(g5)
	  g:Merge(g6)
	  g:Merge(g7)
	  g:Merge(g8)
	  g:Merge(g9)
	  local def=g:GetCount()*500
	  local def2=(c733.a+c733.a2+c733.a3+c733.a4+c733.a5+c733.a6+c733.a7)*500
	  if def>def2 then return def   
	  else return def2 end   
end
function c733.atkvalue2(e)
	  local c=e:GetHandler()  
	local og=c:GetOverlayGroup()
	  local tc=og:GetFirst()
	  local tatk=0
	  while tc do
	  local oatk=tc:GetAttack()
	  if oatk<0 then oatk=0 end
	  tatk=tatk+oatk
	  tc=og:GetNext() end
	  return tatk/2
end

function c733.spcon(e,c)
	if c==nil then return true end
	  return c733.a~=0 and c733.a2~=0 and c733.a3~=0 and c733.a4~=0 and c733.a5~=0 and c733.a6~=0 and Duel.GetLocationCountFromEx(c:GetControler(),c:GetControler(),nil,c)>0
end

function c733.bp2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPosition()==POS_FACEUP_ATTACK
end
function c733.bp2con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPosition()==POS_FACEUP_DEFENSE
end


function c733.rev(e,re,r,rp,rc)
	return bit.band(r,REASON_EFFECT)>0
end

function c733.rebcondition1(e,tp,eg,ep,ev,re,r,rp)
	  if rp==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsControler(e:GetHandler():GetControler()) and tc:IsLocation(LOCATION_MZONE)
	  and re:GetHandler():IsCanBeEffectTarget(e) and re:GetHandler():IsControler(1-e:GetHandlerPlayer())
	  and e:GetHandler():GetFlagEffect(198)==0
end
function c733.rebfilter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c733.rebtarget1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc~=e:GetLabelObject() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and tf(re,rp,ceg,cep,cev,cre,cr,crp,0,chkc) end
	if chk==0 then return Duel.IsExistingTarget(c733.rebfilter,tp,0,LOCATION_MZONE,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c733.rebfilter,tp,0,LOCATION_MZONE,1,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
	  e:GetHandler():RegisterFlagEffect(198,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) 
end
function c733.reboperation1(e,tp,eg,ep,ev,re,r,rp)
	local tf=re:GetTarget()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tf(re,rp,nil,nil,nil,nil,nil,nil,0,tc) then
		  local g=Group.FromCards(tc)
		Duel.ChangeTargetCard(ev,g)
	end
end
function c733.rebcondition2(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsControler(e:GetHandler():GetControler()) and tc:IsLocation(LOCATION_MZONE)
	  and not re:GetHandler():IsCanBeEffectTarget(e) and re:GetHandler():IsControler(1-e:GetHandlerPlayer())
	  and e:GetHandler():GetFlagEffect(198)==0 
end
function c733.reboperation2(e,tp,eg,ep,ev,re,r,rp)
	  e:GetHandler():RegisterFlagEffect(198,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) 
	  Duel.NegateActivation(ev)
	  local c=e:GetHandler()	  
	  local tc=re:GetHandler()
	  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
	  local gtc=g:RandomSelect(tp,1)
	  local gtc2=gtc:GetFirst()
	  if tc then
	local operation=re:GetOperation()
	e:SetProperty(re:GetProperty())
	c:CreateEffectRelation(re)
	Duel.SetTargetCard(gtc2)
	if operation then operation(e,tp,gtc,tp,ev,re,r,rp) end
	c:ReleaseEffectRelation(re) 
	  end
end

function c733.defatktg(e,c)
	return c:IsSetCard(0x3008) or c:IsSetCard(0x5008) or c:IsSetCard(0x6008) or c:IsSetCard(0xa008) or c:IsCode(23204029) 
end

function c733.eqfilter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler() and c:IsType(TYPE_MONSTER)
end
function c733.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE) or chkc:IsLocation(LOCATION_GRAVE)) 
				   and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.IsExistingTarget(c733.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c733.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c733.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	  local atk=0
	if tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			  local og=tc:GetOverlayGroup()
			  if og:GetCount()>0 then Duel.SendtoGrave(og,REASON_RULE) end
			if not Duel.Overlay(c,tc) then return end
			c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1) end end
end

function c733.spoperation(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	  while tg do
	  if tg:IsSetCard(0x3008) then c733.a=c733.a+1 end
	  if tg:IsSetCard(0x5008) then c733.a2=c733.a2+1  end
	  if tg:IsSetCard(0x6008) then c733.a3=c733.a3+1  end
	  if tg:IsSetCard(0xa008) then c733.a4=c733.a4+1  end
	  if tg:IsSetCard(0xc008) then c733.a5=c733.a5+1  end 
	  if tg:IsCode(23204029) or tg:IsSetCard(0x908) then c733.a6=c733.a6+1  end
	  if tg:IsCode(501000018) or tg:IsCode(198) or tg:IsCode(159)  then c733.a6=c733.a7+1  end
	  tg=eg:GetNext() end
end

function c733.efilter(e,te)
	return te:GetHandler():GetControler()~=e:GetHandlerPlayer()
end

function c733.drawtar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c733.drawop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x8) and tc:IsType(TYPE_MONSTER) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else Duel.SendtoGrave(tc,REASON_EFFECT) end
end

function c733.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end

function c733.damgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle()
end
function c733.damgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c733.damgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetAttack()
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end

function c733.skipcost(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then
	  local sel=0
	if Duel.CheckLPCost(tp,4000)==true then sel=sel+1 end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>39 then sel=sel+2 end
	e:SetLabel(sel)
	  return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13718,0))
		sel=Duel.SelectOption(tp,aux.Stringid(13732,4),aux.Stringid(13732,5))+1
	end
	e:SetLabel(sel)
	if sel==1 then Duel.PayLPCost(tp,4000) end
	if sel==2 then 
	  local o=Duel.GetDecktopGroup(tp,40)
	  Duel.SendtoGrave(o,REASON_COST+REASON_EFFECT) end
end
function c733.skipop(e,tp,eg,ep,ev,re,r,rp)
	  local sel=Duel.SelectOption(tp,aux.Stringid(13732,9),aux.Stringid(13732,10),aux.Stringid(13732,11),aux.Stringid(13732,12),aux.Stringid(13732,13))
	  if sel==0 then
	  local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(0,1)
	e5:SetCode(EFFECT_SKIP_DP)
	e5:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e5,tp) end
	  if sel==1 then
	  local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetCode(EFFECT_SKIP_SP)
	e6:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e6,tp) end 
	  if sel==2 then
	  local e7=Effect.CreateEffect(e:GetHandler())
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(0,1)
	e7:SetCode(EFFECT_SKIP_M1)
	e7:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e7,tp) end
	  if sel==3 then
	  local e8=Effect.CreateEffect(e:GetHandler())
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(0,1)
	e8:SetCode(EFFECT_SKIP_BP)
	  e8:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e8,tp) end
	  if sel==4 then
	  local e9=Effect.CreateEffect(e:GetHandler())
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetTargetRange(0,1)
	e9:SetCode(EFFECT_SKIP_M2)
	  e9:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e9,tp) end
	  local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCode(EFFECT_SKIP_M2)
	--if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
		--e2:SetCondition(c733.skipcon)
		--e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	--else
	--e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	--end
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_EP)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BP)
	Duel.RegisterEffect(e4,tp)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_SKIP_M1)
	Duel.RegisterEffect(e5,tp)
end

function c733.skipcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then
	  local sel=0
	  local lp=Duel.GetLP(tp)-1
	  local o=Duel.GetDecktopGroup(tp,99)
	  local ocount=o:GetCount()
	if Duel.CheckLPCost(tp,lp)==true then sel=sel+1 end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then sel=sel+2 end
	e:SetLabel(sel)
	  return sel~=0
	end
	  local lp=Duel.GetLP(tp)-1
	  local o=Duel.GetDecktopGroup(tp,99)
	  local ocount=o:GetCount()
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13718,0))
		sel=Duel.SelectOption(tp,aux.Stringid(13732,6),aux.Stringid(13732,7))+1
	end
	e:SetLabel(sel)
	if sel==1 then Duel.PayLPCost(tp,lp) end
	if sel==2 then 
	  Duel.SendtoGrave(o,REASON_COST+REASON_EFFECT) end
	local e1=Effect.CreateEffect(   e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	  e1:SetCondition(c733.proccon)
	e1:SetOperation(c733.proc)
	e:GetHandler():RegisterEffect(e1)
end
function c733.skipop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCode(EFFECT_SKIP_M2)
	--if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
		--e2:SetCondition(c733.skipcon)
		--e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	--else
	--e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	--end
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_EP)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BP)
	Duel.RegisterEffect(e4,tp)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_SKIP_M1)
	Duel.RegisterEffect(e5,tp)
end
function c733.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c733.proccon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c733.proc(e,tp,eg,ep,ev,re,r,rp)
	if tp~=Duel.GetTurnPlayer() then return end
	  local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	  if ct==2 then Duel.SetLP(tp,0) end
end

function c733.returnop(e,tp,eg,ep,ev,re,r,rp)
	  Duel.SendtoDeck(e:GetHandler(),tp,0,REASON_EFFECT)
end